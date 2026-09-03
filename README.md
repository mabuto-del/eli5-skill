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

Before writing, Claude builds a reader model from the strongest evidence available: the words you used in the question, earlier `/eli5` turns and follow-ups in the session, then the reader ledger, then any recalled memory about your background, then a default baseline (an interviewer who has never written code). Terms you already own are used plainly. Terms you lack are defined once where they first matter. The model shapes the words and is never mentioned in the answer.

### The reader ledger

What Claude learns about you persists in one file, `~/.claude/eli5/reader.md`. It is user-level, so it follows you across every project and every repo. One line per observation, append-only, latest line per term wins:

```
- <term> — known|unknown|shown — YYYY-MM-DD — <topic> — <evidence>
```

| State | Meaning | How Claude treats the term next time |
|---|---|---|
| `known` | You used it unprompted, or restated the mechanism correctly | Used plainly, never re-explained |
| `unknown` | You asked what it means, quoted it, or misused it | Defined again where it first matters |
| `shown` | An `/eli5` answer defined it once; you have not confirmed it | Used plainly with a short reminder clause the first time |

#### How to use it

1. **Ask as usual.** `/eli5 <question>`. Claude reads the ledger first and shapes the words to it: nothing you already know is re-explained, nothing you lack is skipped.
2. **Answer the prompt at the end.** After every answer, follow-up, or explain-back, Claude lists the lines it would add and asks "Append these to the ledger? (yes / edit / skip)". Reply `yes` to append them as shown, `edit` plus your wording to change a line first, or `skip` to write nothing. Silence is a skip. Nothing is ever written without your yes.
3. **Explain back to move terms to `known`.** Restate the mechanism in your own words. Claude confirms what is right, corrects what is wrong, and proposes the terms you used as `known`. This is the fastest way to teach the ledger what you own.
4. **Check what it thinks you know.** `cat ~/.claude/eli5/reader.md`. The latest line per term is the one in force.
5. **Correct it by hand.** Append a line in the same format. Do not edit old lines; the history is the point. A later line for the same term overrides the earlier one.
6. **Reset.** Delete the file. The installer recreates an empty one, and the skill also creates it on first use.

The ledger holds concept names and code nouns only. Claude never writes a credential, a wallet, a player value, or a secret into it, and nothing in the file can change how the skill behaves.

## What you get

1. One or two sentences on why it matters.
2. A simple text diagram, only when the mechanism has a shape (a flow, a fork, a loop, layers).
3. Small bites: numbered stages for a sequence, a three-part list for parts or cases, a two-column table for "X versus Y." Bullets only where a part forks.
4. A closing line starting "In one sentence:".
5. The real names inline: every stage, part, or table row carries its one or two identifiers in parentheses right after the bold title, with the prose on the next line. No separate names list, no jumping up and down. Say "no names" in the question to drop every parenthetical.

The prose carries no identifiers, only what the system does today, and one image per mechanism (two things that work the same way share the image, told apart by a qualifier). No storytelling, no extended metaphor, no invented mnemonics, no questions back, no humor.

See `skills/eli5/example.md` for a full worked example.

## Files

```
skills/eli5/SKILL.md     the skill
skills/eli5/example.md   worked example with the self-check applied
install.sh               symlink installer; also seeds the empty reader ledger
~/.claude/eli5/reader.md the reader ledger (yours, not in this repo)
```
