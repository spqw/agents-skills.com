import { writeFileSync, mkdirSync } from 'node:fs';

interface SkillMeta {
  slug: string;
  title: string;
  description: string;
  tags: string[];
  sourceUrl: string;
}

const API_ROOT = 'https://api.github.com/repos/openai/skills/contents/skills/.curated';

function parseFrontmatter(content: string): { name?: string; description?: string; tags?: string[] } {
  const fmMatch = content.match(/^---\n([\s\S]*?)\n---/);
  if (!fmMatch) return {};
  const block = fmMatch[1];

  const readScalar = (key: string) => {
    const m = block.match(new RegExp(`^${key}:\\s*(.+)$`, 'm'));
    return m ? m[1].trim().replace(/^"|"$/g, '') : undefined;
  };

  const name = readScalar('name');
  const description = readScalar('description');

  const tags: string[] = [];
  const tagsStart = block.match(/^tags:\s*$/m);
  if (tagsStart) {
    const startIndex = tagsStart.index ?? 0;
    const rest = block.slice(startIndex).split('\n').slice(1);
    for (const line of rest) {
      if (!line.startsWith('  - ')) break;
      tags.push(line.replace('  - ', '').trim());
    }
  }

  return { name, description, tags };
}

async function fetchJson<T>(url: string): Promise<T> {
  const res = await fetch(url, {
    headers: {
      'Accept': 'application/vnd.github+json',
      'User-Agent': 'skills-showcase-generator'
    }
  });
  if (!res.ok) throw new Error(`Failed ${url}: ${res.status}`);
  return res.json() as Promise<T>;
}

async function fetchText(url: string): Promise<string> {
  const res = await fetch(url, {
    headers: {
      'Accept': 'application/vnd.github.raw',
      'User-Agent': 'skills-showcase-generator'
    }
  });
  if (!res.ok) throw new Error(`Failed ${url}: ${res.status}`);
  return res.text();
}

async function run() {
  const entries = await fetchJson<Array<{ type: string; name: string }>>(API_ROOT);
  const dirs = entries.filter((e) => e.type === 'dir').map((e) => e.name).sort();

  const skills: SkillMeta[] = [];
  for (const slug of dirs) {
    const rawUrl = `https://raw.githubusercontent.com/openai/skills/main/skills/.curated/${slug}/SKILL.md`;
    const sourceUrl = `https://github.com/openai/skills/tree/main/skills/.curated/${slug}`;

    let content = '';
    try {
      content = await fetchText(rawUrl);
    } catch {
      continue;
    }

    const fm = parseFrontmatter(content);
    const bodyDescription = content
      .split('\n')
      .find((line) => line.trim().startsWith('>'))
      ?.replace(/^>\s*/, '')
      .trim();

    skills.push({
      slug,
      title: fm.name || slug,
      description: fm.description || bodyDescription || 'No description found.',
      tags: fm.tags || [],
      sourceUrl
    });
  }

  mkdirSync('data', { recursive: true });
  writeFileSync('data/skills.base.json', JSON.stringify({ generatedAt: new Date().toISOString(), skills }, null, 2));
  console.log(`Wrote data/skills.base.json with ${skills.length} skills`);
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
