# Worked example

**Question:** How does the notifier retry a failed Slack post?

Note: this example was written 2026-08-28 against `notifier.ts` at the repo root; the file has since moved to `queues/notifier.ts`. The identifiers below reflect the later layout.

## Grasp (done before writing)

`notifier.ts` (stream and SQS paths, `runDeliveryLane`), `slackWebhook.ts` (5 s timeout, throws on non-OK), `retryQueue.ts` (`enqueueDelivery`), `intakeStack.ts` (retry queue `visibilityTimeout: 120`, `maxReceiveCount: 3`; DLQ retention 14 days; `DeadLetterAlarm`). The accepted event is published but nothing consumes it yet — so the prose says "signal is sent," not "player gets credit."

## Fit (decided before writing)

**Reader model.** The question uses "retry," "failed," and "Slack post" unprompted, so those are owned words and stay. The ledger at `~/.claude/eli5/reader.md` was empty. Nothing in the question or the session shows the reader knows what a queue is, so the default baseline applies: queue is unknown, becomes "tray." Anchor: the reader knows what "posting to Slack" is, so the mechanism opens from there.

**Ledger lines appended after the answer:**

```
- retry — known — 2026-08-28 — intake notifier — used in question
- queue — shown — 2026-08-28 — intake notifier — defined as "tray"
- dead-letter queue — shown — 2026-08-28 — intake notifier — defined as "needs a human" tray
```

**Break-up.** The mechanism is a sequence — post, fail, tray, retry, escalate — so numbered stages, not a three-part list.

**Diagram.** The mechanism has a shape (a loop with an exit to a second tray), so one text diagram goes before the stages.

## Output

When a player sends us feedback, we save it first. Once it is saved, nothing can lose it. The rest is about getting it in front of a person without losing it or posting it twice.

```
saved feedback --> post to Slack --> ok? --yes--> done
                        ^            |
                        |            no
                        |            v
                   "try again later" tray  (up to 3 tries)
                                     |
                              still failing
                                     v
                          "needs a human" tray --> alarm
```

1. **The notifier posts.** (`queues/notifier.ts`, `runDeliveryLane`; `slackWebhook.ts`, `AbortSignal.timeout(5_000)`)

   The moment feedback is saved, the notifier wakes up and posts it into the team's Slack channel. Slack gets five seconds to answer. No "got it," and the post has failed.

2. **The failed post goes in a tray.** (`RetryQueue.enqueueDelivery`, the SQS retry queue)

   The notifier does not keep hammering Slack. It drops a full copy of the feedback into a "try again later" tray and moves on, so one bad post never blocks the rest.

3. **The tray hands it back.** (`visibilityTimeout: 120`, `maxReceiveCount: 3` in `cdk/intakeStack.ts`)

   Two minutes later the notifier does the whole job again from the copy.
   - Before posting, it checks whether this feedback is already marked delivered (record `status`, `accepted → delivered`). If it is, it stops. That is why a retry never creates a duplicate.
   - Still down? Back in the tray, another two minutes. Three tries in total. A normal Slack hiccup lasts seconds, not minutes.

4. **Three fails means a human.** (`DeadLetterQueue`, retention 14 days; `DeadLetterAlarm`)

   The copy moves to a second tray marked "needs a human," kept for two weeks. An alarm goes off the moment that tray has one item. A person fixes the real problem, then pushes the item back through with one command (SQS redrive, operator-run).

5. **The reward signal goes first.** (`publishAccepted`; no consumer yet)

   Before any of this, the moment feedback is saved, the notifier sends the reward signal. Nothing acts on it yet, but the order is the point: a Slack problem is our problem, never the player's.

In one sentence: save first, try Slack, retry three times without duplicates, hand the stuck ones to a human with an alarm, and the player's reward never waits on any of it.

## Self-check

- Why it matters first: "we save it first, nothing can lose it." Last sentence starts "In one sentence:".
- Break-up matches the mechanism: a sequence, so numbered stages.
- Five stages, each hands off: post → tray → retry → human → (precondition) signal.
- Anchored to a known thing: opens from "posting to Slack," which the question already used.
- Ledger read before writing (empty); three lines appended after.
- Owned words kept ("retry," "failed," "post"); one unknown (queue) replaced by one image (tray) in one phrase, no story around it.
- Bullets only in step 3, where the retry forks.
- Diagram uses the prose's words ("try again later" tray, "needs a human" tray, alarm) and could be redrawn from the prose alone.
- No identifier in the prose. Each stage carries its one or two identifiers in parentheses on the title line; the prose starts on the next line. The two sub-event bullets in step 3 and 4 carry theirs inline in parentheses, since bullets have no title line.
- No mnemonic, no question to the reader, no humor.
- Design-only claim flagged: reward signal has no consumer yet.
- Word count: about 290 with step titles, diagram and parentheticals excluded.
