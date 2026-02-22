#!/bin/bash
# Ralph Loop — 8-hour autonomous value maximiser for agents-skills.com
# Usage: ./ralph-loop.sh [hours]
#
# Each iteration: Claude reads RALPH.md, assesses highest-value task, executes it, logs it.
# Runs for 8 hours (default) or specified duration.

set -euo pipefail

HOURS=${1:-8}
END_TIME=$(($(date +%s) + HOURS * 3600))
ITERATION=0
LOG_DIR="/home/ubuntu/agents-skills.com/ralph-logs"
PROJECT_DIR="/home/ubuntu/agents-skills.com"

mkdir -p "$LOG_DIR"

echo "=============================================="
echo " Ralph Loop — agents-skills.com"
echo " Duration: ${HOURS} hours"
echo " End time: $(date -d @$END_TIME)"
echo " Log dir: $LOG_DIR"
echo "=============================================="

while [ $(date +%s) -lt $END_TIME ]; do
    ITERATION=$((ITERATION + 1))
    ITER_LOG="$LOG_DIR/iteration-$(printf '%03d' $ITERATION)-$(date +%Y%m%d-%H%M%S).log"

    echo ""
    echo "========================================"
    echo " Iteration $ITERATION — $(date)"
    echo " Time remaining: $(( (END_TIME - $(date +%s)) / 60 )) minutes"
    echo "========================================"

    # Build the prompt for this iteration
    PROMPT=$(cat <<'RALPH_PROMPT'
You are Ralph, an autonomous value maximiser. Read /home/ubuntu/agents-skills.com/RALPH.md for your full instructions.

This is iteration ITER_NUM of an 8-hour autonomous loop. TIME_LEFT minutes remaining.

## Your task this iteration:

1. Read RALPH.md, CHANGELOG.md, ANSWERS.md to understand context
2. Assess: what is the SINGLE highest-value thing you can do right now?
3. Do it. Ship it. Make it live.
4. Append what you did to CHANGELOG.md with timestamp
5. Git add, commit, and push your changes so auto-deploy triggers
6. Print a one-line summary of what you accomplished

Focus on: SEO, content pages, conversion, multi-domain strategy, new experiments.
Each iteration should produce something LIVE and SHIPPED.

Previous iterations are logged in CHANGELOG.md — don't repeat what's already done.
RALPH_PROMPT
)

    # Replace placeholders
    PROMPT="${PROMPT//ITER_NUM/$ITERATION}"
    PROMPT="${PROMPT//TIME_LEFT/$(( (END_TIME - $(date +%s)) / 60 ))}"

    # Run Claude Code with the prompt
    timeout 900 claude --dangerously-skip-permissions -p "$PROMPT" \
        --max-turns 30 \
        2>&1 | tee "$ITER_LOG" || {
        echo "Iteration $ITERATION failed or timed out (15 min limit)"
        echo "$(date) — Iteration $ITERATION: FAILED/TIMEOUT" >> "$PROJECT_DIR/CHANGELOG.md"
    }

    echo "Iteration $ITERATION complete. Sleeping 30s before next..."
    sleep 30
done

echo ""
echo "=============================================="
echo " Ralph Loop complete!"
echo " Total iterations: $ITERATION"
echo " Check $LOG_DIR for logs"
echo "=============================================="
