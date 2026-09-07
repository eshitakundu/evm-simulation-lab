# Preliminary prior-art review

Sources reviewed on September 9, 2026. This is a starting bibliography, not a systematic review or replication. **The project's novelty has not yet been established.** Published methods, vendor capabilities, and this repository's proposed work must not be conflated.

| Source | Relevance and distinction |
| --- | --- |
| [Blockchain Transaction Simulation Phishing](https://arxiv.org/abs/2607.28747) | Studies deceptive differences between previews and later execution. Its SIMGUARD system combines static and dynamic bytecode analysis to identify relevant phishing behavior. This lab neither implements SIMGUARD nor reproduces the paper's attacks or measurements. |
| [Tenderly transaction simulation](https://docs.tenderly.co/simulations/overview) | Offers transaction simulations with traces and state/asset changes. Useful context for what a real simulation baseline could expose. No Tenderly integration or assessment is implemented here. |
| [Blockaid transaction security](https://www.blockaid.io/about) | Describes transaction simulation and other security capabilities. Relevant to the broader protection ecosystem; this repository provides no evidence of a bypass or comparative performance. |
| [MetaMask security alerts](https://support.metamask.io/configure/wallet/security-alerts/) | Explains wallet warnings and simulation-backed checks. Relevant to the user's decision point; this lab does not test MetaMask or its providers. |
| [Smartify: A Multi-Agent Framework for Automated Vulnerability Detection and Repair in Solidity and Move Smart Contracts](https://arxiv.org/abs/2502.18515) | Explores specialized agents for contract analysis and repair. Agent-assisted contract security is existing work; a proposed attacker/defender arrangement alone does not establish novelty. |
| [SPEAR: An Engineering Case Study of Multi-Agent Coordination for Smart Contract Auditing](https://arxiv.org/abs/2602.04418) | Studies coordination and recovery in an auditing workflow. Relevant to orchestration design, rather than evidence that this lab can detect simulation mismatches. |
| [NVIDIA Labs Object-Oriented Agents repository](https://github.com/NVIDIA-NeMo/labs-OO-Agents) and [paper](https://arxiv.org/abs/2607.20709) | Provides a Python object-oriented agent framework. It may support typed roles and explicit tool boundaries in a future evaluation; framework use would not constitute a new security method. NOOA is not installed or implemented here. |

Open review work: read full methods and evaluation assumptions, map existing mismatch taxonomies, compare replay/evidence requirements, and identify whether any defensible research gap remains. No reported detection rates or losses from other work are presented as this project's results.
