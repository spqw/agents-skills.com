# Changelog

## 2026-02-22

### Initial Setup
- Landing page deployed at agents-skills.com
- Cloudflare DNS configured (A records, proxied)
- Coolify deployment with auto-deploy webhook from GitHub
- Demo video rendered with Remotion + ElevenLabs voiceover (51s)
- Pricing: Free / $15 monthly / $49 lifetime early bird
Sun Feb 22 00:11:15 UTC 2026 — Iteration 1: FAILED/TIMEOUT

### SEO Infrastructure & Comparison Page
- Added `robots.txt` with sitemap reference
- Added `sitemap.xml` with homepage and comparison page
- Created `/compare/` — "Best Desktop Automation Tools 2026" comparison page
  - Targets keywords: "best desktop automation tool", "keyboard maestro alternative", "automate repetitive tasks"
  - Side-by-side comparison table: Agents Skills vs Keyboard Maestro vs AutoHotkey vs Power Automate
  - Verdict cards, structured data (Article schema), full SEO meta tags
  - Internal CTAs linking back to download/waitlist
- Updated homepage nav: replaced FAQ link with "Compare" link
- Updated homepage footer: added "Compare Tools" link
Sat Feb 22 2026 — Ralph Iteration 1 (retry): SEO foundation + comparison content page

### Deploy Fix + Ship All Undeployed Content
- **CRITICAL FIX**: Dockerfile was only copying `index.html` — compare page, robots.txt, sitemap.xml were NOT deployed
- Updated Dockerfile to copy ALL content: `compare/`, `dev-recipes/`, `llm-benchmark/`, `vs/`, `robots.txt`, `sitemap.xml`
- Committed 3 previously unshipped content pages built in failed iteration 1:
  - `/dev-recipes/` — 10 copy-paste code cheatsheets (curl, Docker, git, regex, cron, SSH, jq, awk, systemd, nginx)
  - `/llm-benchmark/` — LLM comparison page targeting "Claude vs GPT-4" searches
  - `/vs/vs-keyboard-maestro.html` — Agents Skills vs Keyboard Maestro comparison
- Updated `sitemap.xml` with all 5 pages (home, compare, dev-recipes, llm-benchmark, vs-keyboard-maestro)
- Added internal navigation links on homepage: "Dev Recipes" in nav, "Dev Recipes" + "LLM Benchmark" in footer
- Net result: went from 1 deployed page to 5 deployed pages in one push
Sun Feb 22 2026 — Ralph Iteration 2: Fixed broken Dockerfile + shipped 4 undeployed content pages
