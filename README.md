# evm-simulation-lab

An early Ethereum security research prototype investigating differences between transaction previews and later execution outcomes.

## Current status

**Early research prototype.** Implemented: one local Solidity fake-credit experiment and Foundry tests. Current research: defining mismatch evidence, assumptions, and evaluation criteria. Planned: simulator integration, attacker and defender agents, a general deterministic verifier, and visual reports. No novel security method or complete product is claimed; novelty has not yet been established.

## Problem and motivation

A transaction preview is conditional on the state and execution context used to produce it. State can change before the intended transaction executes. Simulation matters because users use predicted recipients, asset changes, and success or failure to decide whether to proceed. A stale prediction may be misleading even when the simulator correctly evaluated its original inputs.

**Central research question:** Can controlled state perturbations and deterministic replay identify meaningful preview/execution mismatches, and can a defender explain them without treating every benign state change as an attack?

See [problem definition](docs/problem.md), [prior art](docs/prior-art.md), and [threat model](docs/threat-model.md).

## Implemented experiment

`StateDependentPayout` holds a budget of 100 fake credits in the tests. An immutable controller may change the recipient; an immutable operator may record a payout. The test records the initial recipient, prepares `payout(25)` calldata, changes the recipient through the controller, and executes that unchanged calldata as the operator. Assertions check the different recipient, credit balances, conserved budget, and contract events; a test event records the comparison. A stable-state control test checks agreement.

This is **only an educational state-change experiment**. The initial observation is a getter, not a full transaction simulation. It does not reproduce a real transaction-simulation phishing attack or demonstrate a flaw in any wallet or simulation provider. Credits are integers with no redemption or monetary value. There are no ETH transfers, token approvals, or external contract integrations.

## Planned architecture

The proposed pipeline connects contract input, simulation, a constrained attacker agent that proposes local state changes, an execution sandbox, a deterministic verifier, a defender agent, and a visual report. Every pipeline component is **planned**, except the limited local Foundry fixture and its handwritten assertions. Agents would propose and explain; deterministic replay would determine whether evidence supports a mismatch. See the [architecture diagram and component status](docs/architecture.md).

## Safety and ethics

Use only local ephemeral EVMs, invented accounts, and fake balances. Do not connect wallets, use private keys, fork live networks, deploy publicly, or interact with real contracts for these experiments. No phishing interface, wallet-draining logic, or adversarial deployment is included. Any future external study requires a separately reviewed scope and responsible disclosure process. The MIT license is not a safety certification.

## Repository structure

```text
README.md
LICENSE
.gitignore
docs/
  problem.md
  prior-art.md
  threat-model.md
  architecture.md
  research-log.md
contracts/
  foundry.toml
  src/StateDependentPayout.sol
  test/StateDependentPayout.t.sol
experiments/nooa-spike/README.md
.github/workflows/contracts.yml
```

## Local setup and tests

Install Git and [Foundry](https://getfoundry.sh/introduction/installation/). The tested/CI Foundry version is **v1.8.1**; with Foundryup available, run `foundryup --install v1.8.1`. Windows users can follow the official installation guidance or download the matching official release binary. Solidity **0.8.24** is pinned in `foundry.toml` and downloaded by Forge on first use. Initial tool/compiler installation needs network access; tests need no RPC endpoint, API key, wallet, NOOA, or forge-std dependency.

```sh
git clone https://github.com/eshitakundu/evm-simulation-lab.git
cd evm-simulation-lab/contracts
forge --version
forge fmt --check
forge build
forge test -vvv
forge test --match-test test_StateChangeMakesSameIntendedActionCreditDifferentRecipient -vvvv
```

The last command exposes the call trace and comparison event. The GitHub Actions workflow runs formatting, compilation, and the complete test suite. Local verification evidence and its limits are recorded in the [research log](docs/research-log.md); the presence of a workflow alone does not establish a successful hosted run.

## Current limitations

- One toy ledger, one explicit state mutation, and a getter-based observation; no real simulator comparison.
- No mempool, transaction ordering model, block-context variation, production assets, or chain forks.
- Tests check fixture behavior and access rules, not general attack detection or economic harm.
- No dataset, benchmark, detection rates, agent implementation, general verifier, or user interface.
- Prior-art review is preliminary; novelty and effectiveness remain open questions.

## Short roadmap

1. Define a reproducible transaction/context/state evidence schema and stable-state controls.
2. Add paired local simulation/execution replay with explicit allowed perturbations.
3. Build and validate a deterministic verifier before introducing agents.
4. Evaluate constrained attacker/defender agents, optionally comparing NOOA with plain Python orchestration.
5. Measure false positives and false negatives on a documented synthetic corpus; add evidence-based reports.

## References

- [Blockchain Transaction Simulation Phishing / SIMGUARD](https://arxiv.org/abs/2607.28747)
- [Tenderly simulation documentation](https://docs.tenderly.co/simulations/overview)
- [Blockaid](https://www.blockaid.io/about)
- [MetaMask security alerts](https://support.metamask.io/configure/wallet/security-alerts/)
- [Smartify research](https://arxiv.org/abs/2502.18515)
- [SPEAR research](https://arxiv.org/abs/2602.04418)
- [NVIDIA Labs Object-Oriented Agents](https://github.com/NVIDIA-NeMo/labs-OO-Agents)

See [prior art](docs/prior-art.md) for relevance and distinctions. These references are not endorsements or claimed integrations.
