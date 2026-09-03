#!/usr/bin/env bash
# Install the /eli5 skill user-level, as a symlink so `git pull` here
# updates every session. Safe to re-run. Never overwrites a file that is
# not a symlink: your own skill under the same name is left alone and
# reported, so move it aside first if you want this one.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest="$HOME/.claude/skills/eli5"

mkdir -p "$HOME/.claude/skills"

if [[ -L "$dest" ]]; then
  rm "$dest"
elif [[ -e "$dest" ]]; then
  echo "kept $dest — it is not a symlink; move it aside and re-run" >&2
  exit 1
fi

ln -s "$root/skills/eli5" "$dest"
echo "linked $dest -> $root/skills/eli5"

ledger="$HOME/.claude/eli5/reader.md"
if [[ ! -e "$ledger" ]]; then
  mkdir -p "$(dirname "$ledger")"
  printf '%s\n' \
    '# /eli5 reader ledger' \
    '# One line per observation. Latest line per term wins. Append only.' \
    '# - <term> — known|unknown|shown — YYYY-MM-DD — <topic> — <evidence>' \
    > "$ledger"
  echo "seeded empty ledger at $ledger"
fi
echo "Type /eli5 <question> in any Claude Code session."
