# /eli5

A Claude Code skill that explains a technical mechanism to a reader who does not code, fitted to what that reader already knows. Three phases every time: grasp it fully from the source, translate it to plain words, then fit it to something the reader already understands. Why it matters first, small bites, a simple text diagram only when the mechanism has a shape, about 275 words.

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

A follow-up question after an `/eli5` answer stays in this shape and answers only the part asked. A repeated question, a "?", or "what does X mean" is read as confusion, and that one part is re-explained in simpler words.

The skill never fires on its own. Every other answer keeps its normal shape.

## How it fits the reader

Before writing, Claude builds a reader model from the strongest evidence available: the words you used in the question, earlier `/eli5` turns and follow-ups in the session, then any recalled memory about your background, then a default baseline (an interviewer who has never written code). Terms you already own are used plainly. Terms you lack are defined once where they first matter. The model shapes the words and is never mentioned in the answer.

## What you get

1. One or two sentences on why it matters.
2. A simple text diagram, only when the mechanism has a shape (a flow, a fork, a loop, layers).
3. Small bites: numbered stages for a sequence, a three-part list for parts or cases, a two-column table for "X versus Y." Bullets only where a part forks.
4. A closing line starting "In one sentence:".
5. Optionally, a tail titled "If they ask for the real names" — each line starts with a phrase from the prose, then the real file, queue, or field. Included when you may need to act on the answer; say "no names" in the question to leave it out.

The prose carries no identifiers, only what the system does today, and one image per mechanism (two things that work the same way share the image, told apart by a qualifier). No storytelling, no extended metaphor, no invented mnemonics, no questions back, no humor.

See `skills/eli5/example.md` for a full worked example.

## Files

```
skills/eli5/SKILL.md     the skill
skills/eli5/example.md   worked example with the self-check applied
install.sh               symlink installer
```
