# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: [e.g., Bicep, ARM Templates, Terraform or NEEDS CLARIFICATION]  
**Primary Dependencies**: [e.g., Azure CLI, Azure PowerShell, Azure DevOps or NEEDS CLARIFICATION]  
**Storage**: [if applicable, e.g., Azure Storage Account, Key Vault or N/A]  
**Testing**: [e.g., Pester, Azure Resource Manager Template Toolkit or NEEDS CLARIFICATION]  
**Target Platform**: [e.g., Azure Cloud, Hybrid, Multi-cloud or NEEDS CLARIFICATION]
**Project Type**: [infrastructure/landing-zone/workload - determines source structure]  
**Performance Goals**: [e.g., deployment time <30min, RTO <4hrs, RPO <1hr or NEEDS CLARIFICATION]  
**Constraints**: [e.g., compliance requirements, budget limits, region restrictions or NEEDS CLARIFICATION]  
**Scale/Scope**: [e.g., # subscriptions, # regions, # environments or NEEDS CLARIFICATION]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [ ] **Enterprise Scale Foundation**: Architecture aligns with Hub & Spoke topology and management group structure
- [ ] **Well-Architected Framework**: All five pillars (Security, Cost, Operations, Performance, Reliability) assessed
- [ ] **Security & Governance First**: Zero Trust principles, Azure Policy, RBAC, and compliance controls defined
- [ ] **Avanade Value Acceleration**: Unique Avanade capabilities and accelerators identified and leveraged
- [ ] **Infrastructure as Code**: Bicep/ARM templates planned with version control and automated testing

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Landing Zone Infrastructure (DEFAULT)
infrastructure/
├── bicep/
│   ├── modules/
│   ├── templates/
│   └── parameters/
├── policies/
├── scripts/
└── docs/

tests/
├── integration/
├── compliance/
└── validation/

# [REMOVE IF UNUSED] Option 2: Workload Infrastructure (when specific application workload)
workload/
├── infrastructure/
│   ├── bicep/
│   ├── networking/
│   └── security/
├── application/
│   └── [workload-specific structure]
└── tests/

# [REMOVE IF UNUSED] Option 3: Multi-environment (when dev/staging/prod deployment)
environments/
├── shared/
│   ├── bicep/
│   └── policies/
├── dev/
├── staging/
└── production/
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
