# Worked example

**Question:** How does the notifier retry a failed Slack post?

## Grounding (done before writing)

`notifier.ts` (stream and SQS paths, `runDeliveryLane`), `slackWebhook.ts` (5 s timeout, throws on non-OK), `retryQueue.ts` (`enqueueDelivery`), `intakeStack.ts` (retry queue `visibilityTimeout: 120`, `maxReceiveCount: 3`; DLQ retention 14 days; `DeadLetterAlarm`). The accepted event is published but nothing consumes it yet — so the prose says "signal is sent," not "player gets credit."

## Output

When a player sends us feedback, we save it first. Once it is saved, nothing can lose it. The rest is about getting it in front of a person without losing it or posting it twice.

1. **A helper wakes up.** A small program notices the new feedback and posts it into the team's Slack channel. Slack gets five seconds to answer. No "got it," and the post has failed.

2. **The failed post goes in a tray.** The helper does not keep hammering Slack. It drops a full copy of the feedback into a "try again later" tray and moves on, so one bad post never blocks the rest.

3. **The tray hands it back.** Two minutes later the helper does the whole job again from the start.
   - Before posting, it checks whether this feedback already reached Slack. If it did, it stops. That is why a retry never creates a duplicate.
   - Still down? Back in the tray, another two minutes. Three tries in total. A normal Slack hiccup lasts seconds, not minutes.

4. **Three fails means a human.** The copy moves to a second tray marked "needs a human," kept for two weeks. An alarm goes off the moment that tray has one item. A person fixes the real problem, then pushes the item back through with one command.

5. **The reward signal goes first.** Before any of this, the moment feedback is saved, the helper sends the reward signal. Nothing acts on it yet, but the order is the point: a Slack problem is our problem, never the player's.

In one sentence: save first, try Slack, retry three times without duplicates, hand the stuck ones to a human with an alarm, and the player's reward never waits on any of it.

**If they ask for the real names**
- helper — the notifier Lambda, `notifier.ts`
- five seconds — `slackWebhook.ts`, `AbortSignal.timeout(5_000)`
- "try again later" tray — the SQS retry queue, `RetryQueue.enqueueDelivery`
- two minutes / three tries — `visibilityTimeout: 120`, `maxReceiveCount: 3` in `intakeStack.ts`
- already reached Slack — record `status` `accepted → delivered`
- "needs a human" tray — the dead-letter queue, `DeadLetterQueue`; retention 14 days
- alarm — `DeadLetterAlarm`
- one command — SQS redrive, operator-run
- reward signal — `publishAccepted` (accepted event); no consumer yet

## Self-check

- Why it matters first: "we save it first, nothing can lose it." Last sentence starts "In one sentence:".
- Five steps, each a stage that hands off: wake → tray → retry → human → (precondition) signal.
- Bullets only in step 3, where the retry forks.
- No identifier in the prose. Every tail line starts with a phrase from the prose.
- One image (tray) for both queues, qualified.
- Design-only claim flagged: reward signal has no consumer yet.
- Word count: about 290 with step titles, tail excluded.
