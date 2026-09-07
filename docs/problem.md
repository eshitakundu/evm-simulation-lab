# Problem definition

Transaction-simulation mismatch means that an outcome predicted before submission differs from an outcome observed during later execution. A useful study must identify both the prediction's assumptions and the inputs that changed. EVM execution is deterministic for fixed complete inputs; different outcomes across different states do not imply nondeterminism or a simulator bug.

Let `T` describe the sender, target, calldata, value, and gas parameters; let `S` and `C` describe state and execution context. Compare a declared outcome projection of `execute(T, S0, C0)` with `execute(T, S1, C1)`. Relevant projections may include success/revert, credited recipient, asset balance deltas, and logs. Gas-only differences need their own policy and should not automatically count as user harm.

The current fixture observes `previewRecipient()` at S0, changes the recipient to produce S1, then calls `payout(25)`. It demonstrates only that a getter-based expectation can become stale. It does not yet implement the paired executions above. The changed state is explicit and authorized by the toy controller; a mismatch does not establish malicious intent.

Research questions:

- Which state/context changes are feasible under the declared attacker permissions?
- Can a reproducible witness isolate the cause while preserving the intended transaction?
- Which divergences matter to a user, and which are benign or expected?
- Can an explanation help without asserting stronger protection than the evidence supports?

Next research step: specify complete replay artifacts, stable-state controls, and an outcome comparison policy before connecting any agent or external simulator. See [prior art](prior-art.md) and [threat model](threat-model.md). No novelty claim is currently justified.
