# Threat model — preliminary

## Protected user

A person deciding whether to submit an Ethereum transaction using a preview of its effects. Desired protection: an evidence-based warning when an allowed change can invalidate a meaningful expectation. The current fixture has only an invented operator account; no real user wallet is involved.

## Possible attacker and control

In the proposed study, an adversary may control a synthetic contract and explicitly permitted state-changing calls between observation and execution. In the implemented fixture, the fake controller can change only the recipient, while the fake operator alone can call `payout`. Roles are immutable; there is no ownership-transfer or upgrade interface. Read functions are public. The controller cannot spend the budget, and the operator cannot change the recipient when the roles are distinct as configured in tests.

The model does not grant control over the user's signed calldata, arbitrary storage writes, private keys, consensus, or unrestricted transaction ordering. Future context perturbations must be declared and justified separately. Test impersonation is a local harness capability, not evidence that a real attacker can impersonate an account.

## Defender observations

Planned inputs include source/bytecode hashes, initial state and context, transaction fields, allowed intervening calls, preview output, replay traces, receipts, and relevant state differences. A defender cannot assume knowledge of future chain state or infer intent solely from a changed recipient. Currently a human can inspect the Solidity fixture, its assertions, and Forge traces; no defender agent exists.

## Verified mismatch criteria

A future verifier must retain a reproducible witness: identical intended transaction fields across paired runs, recorded initial state/context, explicit permitted changes, execution results, and a comparison of the declared outcome projection. Replay must support the difference independently of an agent's prose. Repeatable agreement under unchanged inputs is a negative control. Missing artifacts or unsuccessful replay mean inconclusive evidence, not a verified mismatch.

The current test verifies a narrower **observation/execution recipient difference**: initial getter recipient FIRST, authorized mutation to SECOND, unchanged prepared payout calldata executed by the operator, checked event fields and fake-credit balances. It is not a verified real-simulator discrepancy or proof of phishing.

## Errors and uncertainty

- False positives: benign recipient updates; expected slippage; incomparable states or transaction fields; event-only differences without the claimed balance effect; classifying every mismatch as malicious.
- False negatives: untested state changes, omitted block context, incomplete outcome projections, limited exploration, incorrect preview assumptions, or agent failure to propose a relevant case.
- No dataset or measured error rates exist. Separate the correctness of a recorded divergence from any judgment that it is harmful.

## Experiment boundaries

Only local ephemeral EVM execution, invented accounts, fake credits/balances, and repository-owned synthetic fixtures are allowed. No live RPC/forks, public deployments, real contracts, real keys, wallet connections, phishing UX, token approvals, or asset extraction. The contract accepts no payable action and makes no external calls. Future agents must use allowlisted local tools, bounded execution budgets, and untrusted-input handling; those enforcement mechanisms remain planned. Any broader experiment needs a new explicit scope and safety review.
