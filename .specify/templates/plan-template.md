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

**IaC Language**: [Bicep (preferred) or Terraform - NO ARM templates]  
**Azure Verified Modules**: [List specific AVM modules to be used or NEEDS CLARIFICATION]  
**Landing Zone Type**: [Enterprise Scale Foundation/Hub-Spoke/Virtual WAN or NEEDS CLARIFICATION]  
**Target Subscriptions**: [Management groups and subscription organization or NEEDS CLARIFICATION]  
**Azure Regions**: [Primary and secondary regions for deployment or NEEDS CLARIFICATION]
**Project Type**: [infrastructure/workload/platform - determines source structure]  
**Performance Goals**: [RTO/RPO targets, throughput requirements or NEEDS CLARIFICATION]  
**Compliance Requirements**: [Regulatory standards, data residency or NEEDS CLARIFICATION]  
**Scale/Scope**: [Number of workloads, users, resources expected or NEEDS CLARIFICATION]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**GitHub Flow Compliance**:
- ✅ Feature branch `[###-feature-name]` created from main/default branch
- ✅ Task-level branching strategy documented (each task gets separate branch from feature branch)
- ✅ Branch protection rules planned for feature and main branches
- ✅ Pull request workflow defined (task branches → feature branch → main)
- ✅ No direct commits to feature branch planned (all via task branch PRs)

[Additional gates determined based on constitution file]

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
  real paths (e.g., workloads/web-app, modules/networking). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Infrastructure project (DEFAULT)
modules/
├── networking/
├── security/
├── compute/
└── monitoring/

environments/
├── dev/
├── test/
├── staging/
└── prod/

tests/
├── unit/
├── integration/
└── e2e/

# [REMOVE IF UNUSED] Option 2: Enterprise Scale Landing Zone
management-groups/
├── policies/
└── rbac/

subscriptions/
├── connectivity/
├── identity/
├── management/
└── landing-zones/

shared-services/
├── networking/
├── security/
└── monitoring/

# [REMOVE IF UNUSED] Option 3: Multi-workload platform
platform/
├── networking/
├── shared-services/
└── policies/

workloads/
├── [workload-name]/
│   ├── modules/
│   ├── environments/
│   └── tests/
└── shared/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
