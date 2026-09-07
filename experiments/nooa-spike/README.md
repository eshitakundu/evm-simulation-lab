# NOOA evaluation note — planned only

[NVIDIA Labs Object-Oriented Agents](https://github.com/NVIDIA-NeMo/labs-OO-Agents) ([paper](https://arxiv.org/abs/2607.20709)) may be evaluated after a deterministic replay harness and evidence schema exist. Its Python class-based agent interface could help express attacker and defender roles, typed tool interfaces, and per-case state.

**Nothing is installed or implemented here.** This directory contains only this note. There is no NOOA dependency, agent code, model configuration, API credential, or evaluation result. Framework adoption would not establish research novelty.

Proposed evaluation:

1. Establish a plain Python deterministic orchestration baseline.
2. Compare a small NOOA prototype on tool-boundary enforcement, traceability, structured evidence handling, failure recovery, setup complexity, and execution cost.
3. Check that untrusted contract content cannot expand tool permissions and that agents cannot alter verifier verdicts.
4. Use only local synthetic fixtures and fake balances; no RPC, wallet, public deployment, or real asset access.
5. Record reproducibility limits: fixed prompts/settings do not guarantee deterministic model output. Keep verification independent of model output.

Adopt a framework only if measured benefits justify added complexity. Installation and implementation are deferred.
