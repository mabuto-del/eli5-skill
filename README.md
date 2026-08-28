# /eli5

A Claude Code skill that rewrites a technical explanation for an interviewer with no coding or system-design knowledge: why it matters first, plain words, analogies only where a layperson has no word, numbered stages, about 275 words.

The name is historical. The register is "smart person who has never written code," not "five-year-old."

## Install

```sh
git clone https://github.com/mabuto-del/eli5-skill.git ~/Developer/eli5-skill
~/Developer/eli5-skill/install.sh
```

This symlinks `skills/eli5` into `~/.claude/skills/eli5`. Nothing is copied, so `git pull` in the clone updates every session. Re-running the installer is safe. It never overwrites a file of yours that is not a symlink.

To update: `git -C ~/Developer/eli5-skill pull`.

To remove: `rm ~/.claude/skills/eli5`.

## Use

Two call forms, and only two.

- `/eli5 <question>` — answer a fresh question in this shape. Claude grounds the mechanism first (reads the code), then writes.
- `/eli5` — rewrite Claude's previous answer in this shape. Adds nothing the previous answer did not contain. If the previous turn was not an explanation, it says so in one line and stops.

The skill never fires on its own. Every other answer keeps its normal shape.

## What you get

1. One or two sentences on why it matters.
2. Numbered steps, one per stage; bullets only where a step forks.
3. A closing line starting "In one sentence:".
4. Optionally, a tail titled "If they ask for the real names" — each line starts with a phrase from the prose, then the real file, queue, or field. Included when you may need to act on the answer; say "no names" in the question to leave it out.

The prose carries no identifiers, only what the system does today, and one image per mechanism (two things that work the same way share the image, told apart by a qualifier).

See `skills/eli5/example.md` for a full worked example.

## Files

```
skills/eli5/SKILL.md     the skill
skills/eli5/example.md   worked example with the self-check applied
install.sh               symlink installer
```
