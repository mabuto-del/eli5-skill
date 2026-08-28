---
name: eli5
description: Rewrite a technical explanation for an interviewer with no coding or system-design knowledge — why it matters first, plain words, analogies only where a layperson has no word, numbered stages, about 275 words. Use ONLY when the user runs /eli5. Never trigger on your own, and never change the shape of any other answer.
---

# ELI5

Explain the system to a smart person who has never written code. The name is historical; the register is "interviewer," not "five-year-old."

## Input

- `/eli5 <question>` — answer the question in this shape. Ground it first: read code, config, or vault pages as you would for any explanation. Do not invent a mechanism to fit a story.
- `/eli5` alone — rewrite your previous answer in this shape. Add nothing the previous answer did not contain. If the previous turn was not an explanation, say so in one line and stop.

## Audience

An interviewer with no coding or system-design knowledge. They know what a program, a file, a message, a channel, an alarm, and a command are. They do not know what a queue, a stream, a token, a handler, or a transaction is.

## Shape

1. **Open with why it matters.** One or two sentences: what is at stake, what the system protects.
2. **Numbered steps, one per stage.** A stage is one thing the system does before handing off to the next. Bold title of a few words, then the prose.
3. **Bullets only where a step has sub-events** — an ordered checklist inside one stage, or a fork with two outcomes. Never bullets for style.
4. **Close with one sentence that says the whole thing.** Start it "In one sentence:".
5. **Optional tail — "If they ask for the real names."** Each line starts with the exact phrase from the prose, then the real identifier. Include it only when the reader may need to act or grep; omit for spoken use.

Target length: 275 words, more or less. The tail does not count.

## Words

- **Plain words wherever a layperson has one.** "Save," "post," "check," "wait," "copy," "alarm," "command." Keep them.
- **Analogy only where they do not.** A queue has no lay word; it becomes a tray. A token becomes a pass. Do not replace a word the reader already owns.
- **One image per mechanism.** Two things that work the same way share the image, told apart by a qualifier: the "try again later" tray and the "needs a human" tray. Never two unrelated images for two related things.
- **One idea per sentence.** No word cap. Split rather than squeeze.
- **No real names in the prose.** No file names, function names, service names, field names, codes, or numbers with units that only mean something to an engineer. Plain quantities are fine: "five seconds," "three tries," "two weeks."
- **Only what is live today.** If the design says a thing will happen and the code does not do it yet, say what is sent or stored, not what is achieved, and flag it in one clause. Never let the story claim more than the system does.

## Self-check before sending

- First paragraph says why it matters; last sentence starts "In one sentence:".
- Every numbered step is a stage that hands off to the next. No step is a detail of another.
- No real identifier appears in the prose. If one is needed, it is in the tail, keyed by a phrase that appears verbatim above.
- Every analogy stands for a mechanism the reader has no word for. Same mechanism, same image.
- Every claim is true of the running system today. Design-only claims are flagged.
- Word count is near 275, tail excluded.

## Precedence

Inside `/eli5` output this register wins over any other output-shaping rule (STE, brevity, structure). Outside `/eli5` output nothing changes.

## Boundaries

- This is a reading aid. It is not a proof, a review verdict, a spec, or a runbook. Never substitute it for one.
- Do not run it on `/proof`, `/review`, `/spec` output unless the user runs `/eli5` on that output explicitly.
- Same secrecy rules as any answer: no credentials, no player data, no secret values. A parameter *name* may appear in the tail; its value never does.

## Worked example

See `example.md` in this folder — the intake notifier's Slack retry, written to this shape, with the names tail and the self-check applied.
