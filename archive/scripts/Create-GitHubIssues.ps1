# Create-GitHubIssues.ps1
# Script to create individual GitHub issues for all 98 Azure Cloud Foundation tasks
# Each task becomes a separate issue for granular tracking and prioritization

# Prerequisites:
# 1. Install GitHub CLI: winget install GitHub.cli
# 2. Authenticate: gh auth login
# 3. Run from repository root

param(
    [string]$Repository = "patriek-van-dorp/cloud-quick-start-infra",
    [switch]$WhatIf = $false
)

Write-Host "Creating Individual GitHub Issues for All 98 Azure Cloud Foundation Tasks" -ForegroundColor Green
Write-Host "Repository: $Repository" -ForegroundColor Yellow
Write-Host "What-If Mode: $WhatIf" -ForegroundColor Yellow
Write-Host ""

$issueCount = 0

function New-GitHubIssue {
    param(
        [string]$Title,
        [string]$Body,
        [string[]]$Labels,
        [string]$Repository,
        [switch]$WhatIf
    )
    
    $script:issueCount++
    
    if ($WhatIf) {
        Write-Host "WHAT-IF: Would create issue #$script:issueCount : $Title" -ForegroundColor Cyan
        Write-Host "Labels: $($Labels -join ', ')" -ForegroundColor Gray
        return
    }
    
    try {
        $labelString = $Labels -join ','
        $result = gh issue create --repo $Repository --title $Title --label $labelString --body $Body
        Write-Host "✓ Created issue #$script:issueCount : $Title" -ForegroundColor Green
        return $result
    }
    catch {
        Write-Error "Failed to create issue: $Title - Error: $($_.Exception.Message)"
    }
}

# ==============================================================================
# Phase 1: Setup (Project Foundation) - High Priority
# ==============================================================================

# T001
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T001 - Create repository structure for Enterprise Scale Landing Zone" `
    -Labels @("phase-1", "high-priority", "foundation", "setup", "t001") `
    -Body @"
## Task T001
**Phase 1: Setup (Project Foundation)**

### Objective
Create repository structure for Enterprise Scale Landing Zone in root directory

### Priority
**High** - Foundation for all other work

### Estimated Effort
8 hours maximum

### Dependencies
None - starting task

### Acceptance Criteria
- Repository structure follows Enterprise Scale Landing Zone patterns
- Directory structure supports all planned modules and environments
- Documentation describes the repository layout
- Structure enables proper separation of concerns

### Human Approval Required ⚠️
Review and approve project structure before proceeding
"@

# T002
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T002 - Setup development environment configuration" `
    -Labels @("phase-1", "high-priority", "devcontainer", "setup", "parallel", "t002") `
    -Body @"
## Task T002 [P]
**Phase 1: Setup (Project Foundation)**

### Objective
Setup development environment configuration in `.devcontainer/devcontainer.json`

### Priority
**High** - Foundation for development workflow

### Estimated Effort
8 hours maximum

### Dependencies
- T001 (Repository structure)

### Parallel Execution
Can run in parallel with T003-T007 (marked with [P])

### Acceptance Criteria
- Development environment is containerized and reproducible
- All required tools are installed and configured
- VS Code extensions are properly configured
- Environment supports Bicep development and Azure CLI

### Human Approval Required ⚠️
Review development environment setup
"@

# T003
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T003 - Create main Bicep entry point file" `
    -Labels @("phase-1", "high-priority", "bicep", "setup", "parallel", "t003") `
    -Body @"
## Task T003 [P]
**Phase 1: Setup (Project Foundation)**

### Objective
Create main Bicep entry point file in `main.bicep`

### Priority
**High** - Core infrastructure entry point

### Estimated Effort
8 hours maximum

### Dependencies
- T001 (Repository structure)

### Parallel Execution
Can run in parallel with T002, T004-T007 (marked with [P])

### Acceptance Criteria
- Main Bicep file orchestrates all modules properly
- Parameters are properly defined and documented
- Module references are correct and functional
- Entry point supports multiple environments

### Human Approval Required ⚠️
Review Bicep architecture
"@

# T004
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T004 - Setup Azure Verified Modules registry configuration" `
    -Labels @("phase-1", "high-priority", "bicep", "avm", "parallel", "t004") `
    -Body @"
## Task T004 [P]
**Phase 1: Setup (Project Foundation)**

### Objective
Setup Azure Verified Modules registry configuration in `bicepconfig.json`

### Priority
**High** - Required for module reuse

### Estimated Effort
8 hours maximum

### Dependencies
- T001 (Repository structure)

### Parallel Execution
Can run in parallel with T002-T003, T005-T007 (marked with [P])

### Acceptance Criteria
- bicepconfig.json properly configured for AVM
- Module registry settings enable verified module usage
- Configuration supports private and public modules
- Bicep compilation works with AVM references

### Human Approval Required ⚠️
Review module registry configuration
"@

# T005
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T005 - Create PowerShell deployment scripts" `
    -Labels @("phase-1", "high-priority", "powershell", "deployment", "parallel", "t005") `
    -Body @"
## Task T005 [P]
**Phase 1: Setup (Project Foundation)**

### Objective
Create PowerShell deployment scripts in `scripts/Deploy-Foundation.ps1`

### Priority
**High** - Required for automated deployment

### Estimated Effort
8 hours maximum

### Dependencies
- T001 (Repository structure)

### Parallel Execution
Can run in parallel with T002-T004, T006-T007 (marked with [P])

### Acceptance Criteria
- PowerShell scripts handle all deployment scenarios
- Error handling is comprehensive and informative
- Scripts support multiple environments
- Deployment process is idempotent and reliable

### Human Approval Required ⚠️
Review deployment automation
"@

# T006
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T006 - Setup development environment parameter files" `
    -Labels @("phase-1", "high-priority", "parameters", "dev", "parallel", "t006") `
    -Body @"
## Task T006 [P]
**Phase 1: Setup (Project Foundation)**

### Objective
Setup environment parameter files in `environments/dev-parameters.json`

### Priority
**High** - Required for environment-specific deployments

### Estimated Effort
8 hours maximum

### Dependencies
- T001 (Repository structure)

### Parallel Execution
Can run in parallel with T002-T005, T007 (marked with [P])

### Acceptance Criteria
- Development parameters are properly configured
- Parameters support all planned Azure resources
- Configuration enables development workflow
- Parameters follow naming conventions

### Human Approval Required ⚠️
Review development environment configuration
"@

# T007
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T007 - Setup production environment parameter files" `
    -Labels @("phase-1", "high-priority", "parameters", "prod", "parallel", "t007") `
    -Body @"
## Task T007 [P]
**Phase 1: Setup (Project Foundation)**

### Objective
Setup environment parameter files in `environments/prod-parameters.json`

### Priority
**High** - Required for production deployment

### Estimated Effort
8 hours maximum

### Dependencies
- T001 (Repository structure)

### Parallel Execution
Can run in parallel with T002-T006 (marked with [P])

### Acceptance Criteria
- Production parameters are properly configured
- Parameters meet enterprise security requirements
- Configuration supports production workloads
- Parameters are validated and tested

### Human Approval Required ⚠️
Review production environment configuration
"@

# T008
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T008 - Create GitHub Actions workflow for CI/CD" `
    -Labels @("phase-1", "high-priority", "cicd", "github-actions", "t008") `
    -Body @"
## Task T008
**Phase 1: Setup (Project Foundation)**

### Objective
Create GitHub Actions workflow for CI/CD in `.github/workflows/deploy-foundation.yml`

### Priority
**High** - Required for automated deployment pipeline

### Estimated Effort
8 hours maximum

### Dependencies
- T002-T007 (All parallel setup tasks)

### Acceptance Criteria
- CI/CD pipeline supports all environments
- Workflow includes proper validation and testing
- Deployment process is secure and auditable
- Pipeline supports approval gates for production

### Human Approval Required ⚠️
Review CI/CD pipeline configuration
"@

# T009
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T009 - Create validation script for repository structure" `
    -Labels @("phase-1", "high-priority", "testing", "validation", "t009") `
    -Body @"
## Task T009
**Phase 1: Setup (Project Foundation)**

### Objective
Create validation script for repository structure in `scripts/Test-RepoStructure.ps1`

### Priority
**High** - Required validation before proceeding

### Estimated Effort
8 hours maximum

### Dependencies
- T001-T008 (All setup tasks)

### Acceptance Criteria
- Validation script checks all repository components
- Script provides clear pass/fail results
- Validation covers directory structure and file presence
- Script can be integrated into CI/CD pipeline

### Human Approval Required ⚠️
Review validation approach
"@

# T010
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T010 - Validate development environment setup and tool versions" `
    -Labels @("phase-1", "high-priority", "testing", "validation", "t010") `
    -Body @"
## Task T010
**Phase 1: Setup (Project Foundation)**

### Objective
Validate development environment setup and tool versions in `scripts/Test-Prerequisites.ps1`

### Priority
**High** - Gate to Phase 2

### Estimated Effort
8 hours maximum

### Dependencies
- T009 (Repository structure validation)

### Acceptance Criteria
- All tools are properly installed and configured
- Version requirements are met
- Development environment is fully functional
- Prerequisites validation passes completely

### Human Approval Required ⚠️
Final validation before proceeding to infrastructure
"@

# ==============================================================================
# Phase 2: Foundational Infrastructure - Critical Priority
# ==============================================================================

# T011
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T011 - Create management group hierarchy Bicep module" `
    -Labels @("phase-2", "critical-priority", "management-groups", "bicep", "t011") `
    -Body @"
## Task T011
**Phase 2: Foundational Infrastructure**

### Objective
Create management group hierarchy Bicep module in `modules/management-groups/main.bicep`

### Priority
**Critical** - Blocks all user stories

### Estimated Effort
8 hours maximum

### Dependencies
- T010 (Prerequisites validation)

### Acceptance Criteria
- Bicep module creates 8-level management group hierarchy
- Module supports Toyota Louwmans FS organizational structure
- Management groups follow enterprise naming conventions
- Module is parameterized and reusable

### Human Approval Required ⚠️
Review management group design
"@

# T012
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T012 - Create subscription vending Bicep module" `
    -Labels @("phase-2", "critical-priority", "subscriptions", "bicep", "parallel", "t012") `
    -Body @"
## Task T012 [P]
**Phase 2: Foundational Infrastructure**

### Objective
Create subscription vending Bicep module in `modules/subscriptions/main.bicep`

### Priority
**Critical** - Foundation for subscription management

### Estimated Effort
8 hours maximum

### Dependencies
- T011 (Management group hierarchy module)

### Parallel Execution
Can run in parallel with T013 (marked with [P])

### Acceptance Criteria
- Subscription vending pattern is implemented
- Module supports automated subscription creation
- Subscriptions are properly placed in management groups
- Module follows enterprise governance policies

### Human Approval Required ⚠️
Review subscription vending approach
"@

# T013
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T013 - Create Azure region configuration" `
    -Labels @("phase-2", "critical-priority", "regions", "bicep", "parallel", "t013") `
    -Body @"
## Task T013 [P]
**Phase 2: Foundational Infrastructure**

### Objective
Create Azure region configuration in `modules/regions/main.bicep`

### Priority
**Critical** - Foundation for multi-region deployment

### Estimated Effort
8 hours maximum

### Dependencies
- T011 (Management group hierarchy module)

### Parallel Execution
Can run in parallel with T012 (marked with [P])

### Acceptance Criteria
- Regional configuration supports West Europe (primary)
- Regional configuration supports North Europe (secondary)
- Module enables disaster recovery scenarios
- Configuration follows Azure best practices

### Human Approval Required ⚠️
Review regional architecture
"@

# T014
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T014 - Deploy root management group Toyota Louwmans FS" `
    -Labels @("phase-2", "critical-priority", "deployment", "management-groups", "t014") `
    -Body @"
## Task T014
**Phase 2: Foundational Infrastructure**

### Objective
Deploy root management group "Toyota Louwmans FS" using `modules/management-groups/main.bicep`

### Priority
**Critical** - First actual Azure deployment

### Estimated Effort
8 hours maximum

### Dependencies
- T012 and T013 (Parallel infrastructure modules)

### Acceptance Criteria
- Root management group is successfully deployed
- Management group structure follows design specifications
- Deployment is validated and functional
- Root management group enables further deployments

### Human Approval Required ⚠️
Approve first Azure deployment
"@

# T015
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T015 - Create and deploy 8-level management group hierarchy" `
    -Labels @("phase-2", "critical-priority", "deployment", "hierarchy", "t015") `
    -Body @"
## Task T015
**Phase 2: Foundational Infrastructure**

### Objective
Create and deploy 8-level management group hierarchy per data model specifications

### Priority
**Critical** - Complete foundation structure

### Estimated Effort
8 hours maximum

### Dependencies
- T014 (Root management group deployment)

### Acceptance Criteria
- All 8 management group levels are deployed
- Hierarchy matches data model specifications exactly
- Management groups support planned organizational structure
- Structure enables proper governance and compliance

### Human Approval Required ⚠️
Review complete management group hierarchy
"@

# T016
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T016 - Test management group hierarchy deployment" `
    -Labels @("phase-2", "critical-priority", "testing", "validation", "t016") `
    -Body @"
## Task T016
**Phase 2: Foundational Infrastructure**

### Objective
Test management group hierarchy deployment and verify 8 levels in `scripts/Test-ManagementGroups.ps1`

### Priority
**Critical** - Validation before user stories

### Estimated Effort
8 hours maximum

### Dependencies
- T015 (Complete management group hierarchy)

### Acceptance Criteria
- All 8 management group levels are verified
- Testing script validates structure completely
- Management group properties are correct
- Hierarchy is ready for policy assignments

### Human Approval Required ⚠️
Validate management group structure
"@

# T017
New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "T017 - Validate subscription placement in management groups" `
    -Labels @("phase-2", "critical-priority", "testing", "validation", "t017") `
    -Body @"
## Task T017
**Phase 2: Foundational Infrastructure**

### Objective
Validate subscription placement in correct management groups in `scripts/Test-SubscriptionPlacement.ps1`

### Priority
**Critical** - Gate to user story implementation

### Estimated Effort
8 hours maximum

### Dependencies
- T016 (Management group testing)

### Acceptance Criteria
- Subscription placement follows organizational design
- Validation script confirms correct placement
- Subscriptions inherit management group policies
- Foundation is ready for user story implementation

### Human Approval Required ⚠️
Final foundation validation before user stories
"@

# ==============================================================================
# Phase 3: User Story 1 - Identity and Access Foundation (Priority P1)
# ==============================================================================

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US1-P1] Identity Core Components (T018-T021)" `
    -Labels @("user-story-1", "p1-priority", "identity", "entra-id", "rbac", "bicep") `
    -Body @"
## User Story 1: Identity and Access Foundation (Priority P1)
Complete identity and access management for secure tenant operations

## Tasks
- [ ] **T018** [US1] Create Microsoft Entra ID configuration Bicep module in `modules/identity/entra-id/main.bicep`
- [ ] **T019** [US1] Create RBAC role definitions Bicep module in `modules/identity/rbac/custom-roles.bicep`
- [ ] **T020** [US1] Create conditional access policies Bicep template in `modules/identity/conditional-access/main.bicep`
- [ ] **T021** [US1] Deploy Microsoft Entra ID directory configuration using `modules/identity/entra-id/main.bicep`

## Independent Test Criteria 📋
Create test users, assign roles, verify access controls work correctly

## Human Approval Required ⚠️
Approve each identity component before deployment

## Priority
**P1** - High Priority User Story

## Dependencies
- Issue: Foundation Infrastructure Validation (T016-T017)

## Estimated Effort
32 hours total (8 hours per task)

## Acceptance Criteria
- Microsoft Entra ID is properly configured for Toyota Louwmans FS
- Custom RBAC roles are defined for financial services requirements
- Conditional access policies enforce security standards
- Directory configuration supports corporate integration
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US1-P1] Role-Based Access Control Implementation (T022-T025)" `
    -Labels @("user-story-1", "p1-priority", "rbac", "finance", "compliance", "bicep") `
    -Body @"
## User Story 1: Identity and Access Foundation (Priority P1)
Implement RBAC for IT, Finance, and Compliance teams with FSI-compliant role definitions

## Tasks
- [ ] **T022** [P] [US1] Create IT Administrator role assignments in `modules/identity/rbac/it-admin-roles.bicep`
- [ ] **T023** [P] [US1] Create Finance team role assignments in `modules/identity/rbac/finance-roles.bicep`
- [ ] **T024** [P] [US1] Create Compliance officer role assignments in `modules/identity/rbac/compliance-roles.bicep`
- [ ] **T025** [US1] Deploy custom RBAC roles for FSI compliance in `modules/identity/rbac/main.bicep`

## Priority
**P1** - High Priority User Story

## Parallel Execution Opportunities
Tasks T022-T024 can run in parallel (marked with [P])

## Dependencies
- Issue: Identity Core Components (T018-T021)

## Estimated Effort
32 hours total (8 hours per task)

## Acceptance Criteria
- IT administrators have appropriate Azure management permissions
- Finance team has access to cost management and budgeting tools
- Compliance officers have audit and monitoring capabilities
- All role assignments follow principle of least privilege
- FSI compliance requirements are met
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US1-P1] Authentication & Authorization (T026-T028)" `
    -Labels @("user-story-1", "p1-priority", "authentication", "conditional-access", "emergency-access") `
    -Body @"
## User Story 1: Identity and Access Foundation (Priority P1)
Configure authentication systems and emergency access procedures for business continuity

## Tasks
- [ ] **T026** [US1] Configure corporate directory integration in `modules/identity/directory-integration/main.bicep`
- [ ] **T027** [US1] Deploy conditional access policies for financial services compliance
- [ ] **T028** [US1] Setup emergency access accounts with break-glass procedures in `modules/identity/emergency-access/main.bicep`

## Priority
**P1** - High Priority User Story

## Dependencies
- Issue: Role-Based Access Control Implementation (T022-T025)

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- Corporate directory integration enables SSO
- Conditional access policies enforce MFA and device compliance
- Emergency access accounts are configured with proper safeguards
- Break-glass procedures are documented and tested
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US1-P1] Identity Testing and Validation (T029-T031, T097)" `
    -Labels @("user-story-1", "p1-priority", "testing", "validation", "emergency-access") `
    -Body @"
## User Story 1: Identity and Access Foundation (Priority P1)
Comprehensive testing and validation of identity implementation and emergency procedures

## Tasks
- [ ] **T029** [US1] Test user authentication with corporate credentials in `scripts/Test-Authentication.ps1`
- [ ] **T030** [US1] Test role assignments and permission verification in `scripts/Test-RBAC.ps1`
- [ ] **T031** [US1] Test emergency access scenarios and break-glass procedures in `scripts/Test-EmergencyAccess.ps1`
- [ ] **T097** [US1] Test emergency access 4-hour time limits and automatic extension workflows in `scripts/Test-EmergencyAccessTimeLimits.ps1`

## Priority
**P1** - High Priority User Story

## Dependencies
- Issue: Authentication & Authorization (T026-T028)

## Human Approval Required ⚠️
Validate all identity components before proceeding to next user story

## Estimated Effort
32 hours total (8 hours per task)

## Acceptance Criteria
- User authentication works seamlessly with corporate credentials
- All role assignments are verified and functional
- Emergency access procedures work as designed
- 4-hour time limits and extension workflows are operational
- All identity security controls are validated
"@

# ==============================================================================
# Phase 4: User Story 2 - Governance and Compliance Framework (Priority P2)
# ==============================================================================

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US2-P2] FSI Compliance Policy Framework (T032-T036)" `
    -Labels @("user-story-2", "p2-priority", "governance", "compliance", "fsi", "sox", "pci", "gdpr") `
    -Body @"
## User Story 2: Governance and Compliance Framework (Priority P2)
Implement FSI regulatory compliance controls and audit capabilities

## Tasks
- [ ] **T032** [US2] Create FSI compliance policy set in `modules/governance/policies/fsi-compliance.bicep`
- [ ] **T033** [P] [US2] Create SOX compliance policies in `modules/governance/policies/sox-compliance.bicep`
- [ ] **T034** [P] [US2] Create PCI DSS compliance policies in `modules/governance/policies/pci-compliance.bicep`
- [ ] **T035** [P] [US2] Create GDPR compliance policies in `modules/governance/policies/gdpr-compliance.bicep`
- [ ] **T036** [US2] Deploy policy assignments to management groups using `modules/governance/policy-assignments/main.bicep`

## Human Approval Required ⚠️
Review each compliance policy before enforcement

## Independent Test Criteria 📋
Implement policies, verify enforcement, demonstrate audit capabilities

## Priority
**P2** - Medium Priority User Story

## Parallel Execution Opportunities
Tasks T033-T035 can run in parallel (marked with [P])

## Dependencies
- User Story 1 (US1) must be completed for role-based policy assignments

## Estimated Effort
40 hours total (8 hours per task)

## Acceptance Criteria
- FSI compliance policies are comprehensive and enforced
- SOX, PCI DSS, and GDPR requirements are met
- Policy assignments are properly scoped to management groups
- Compliance violations are prevented and detected
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US2-P2] Audit and Compliance Monitoring (T037-T040, T098)" `
    -Labels @("user-story-2", "p2-priority", "audit", "monitoring", "compliance", "retention") `
    -Body @"
## User Story 2: Governance and Compliance Framework (Priority P2)
Establish comprehensive audit capabilities with 7-year retention for regulatory compliance

## Tasks
- [ ] **T037** [US2] Create compliance dashboard configuration in `modules/governance/compliance-dashboard/main.bicep`
- [ ] **T038** [US2] Setup 7-year audit log retention in `modules/governance/audit-retention/main.bicep`
- [ ] **T098** [US2] Create automated audit data archival and retrieval system in `modules/governance/audit-lifecycle/main.bicep`
- [ ] **T039** [US2] Configure policy violation alerting in `modules/governance/compliance-alerts/main.bicep`
- [ ] **T040** [US2] Deploy Azure Security Center compliance dashboard configuration

## Priority
**P2** - Medium Priority User Story

## Dependencies
- Issue: FSI Compliance Policy Framework (T032-T036)

## Estimated Effort
40 hours total (8 hours per task)

## Acceptance Criteria
- Compliance dashboard provides real-time visibility
- 7-year audit retention meets regulatory requirements
- Automated archival and retrieval systems are operational
- Policy violation alerts reach appropriate stakeholders
- Azure Security Center compliance dashboard is configured
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US2-P2] Resource Governance and Naming Standards (T041-T043)" `
    -Labels @("user-story-2", "p2-priority", "governance", "naming", "tagging", "policies") `
    -Body @"
## User Story 2: Governance and Compliance Framework (Priority P2)
Implement resource governance with standardized naming and tagging for compliance tracking

## Tasks
- [ ] **T041** [P] [US2] Create resource naming convention policies in `modules/governance/naming/naming-policies.bicep`
- [ ] **T042** [P] [US2] Create resource tagging policies for compliance in `modules/governance/tagging/compliance-tags.bicep`
- [ ] **T043** [US2] Deploy governance policies across all management groups

## Priority
**P2** - Medium Priority User Story

## Parallel Execution Opportunities
Tasks T041-T042 can run in parallel (marked with [P])

## Dependencies
- Issue: Audit and Compliance Monitoring (T037-T040, T098)

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- Resource naming follows consistent enterprise standards
- Compliance tagging is enforced across all resources
- Governance policies are applied to entire management group hierarchy
- Resource discovery and compliance tracking are automated
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US2-P2] Governance Testing and Validation (T044-T046)" `
    -Labels @("user-story-2", "p2-priority", "testing", "validation", "compliance") `
    -Body @"
## User Story 2: Governance and Compliance Framework (Priority P2)
Comprehensive testing of policy enforcement and compliance reporting capabilities

## Tasks
- [ ] **T044** [US2] Test policy enforcement and violation blocking in `scripts/Test-PolicyEnforcement.ps1`
- [ ] **T045** [US2] Test compliance reporting and audit data collection in `scripts/Test-ComplianceReporting.ps1`
- [ ] **T046** [US2] Test violation alerting to compliance team in `scripts/Test-ComplianceAlerts.ps1`

## Priority
**P2** - Medium Priority User Story

## Dependencies
- Issue: Resource Governance and Naming Standards (T041-T043)

## Human Approval Required ⚠️
Validate compliance framework before proceeding

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- Policy enforcement prevents non-compliant deployments
- Compliance reporting captures all required audit data
- Violation alerts are delivered to appropriate teams
- End-to-end compliance workflow is validated
"@

# ==============================================================================
# Phase 5: User Story 3 - Cost Management and Resource Governance (Priority P3)
# ==============================================================================

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US3-P3] Budget Management and Hierarchy (T047-T050)" `
    -Labels @("user-story-3", "p3-priority", "cost-management", "budgets", "finance") `
    -Body @"
## User Story 3: Cost Management and Resource Governance (Priority P3)
Implement cost visibility, budget controls, and resource optimization

## Tasks
- [ ] **T047** [US3] Create hierarchical budget structure in `modules/cost-management/budgets/hierarchy-budgets.bicep`
- [ ] **T048** [P] [US3] Create department-specific budgets in `modules/cost-management/budgets/department-budgets.bicep`
- [ ] **T049** [P] [US3] Create project-based cost tracking in `modules/cost-management/budgets/project-budgets.bicep`
- [ ] **T050** [US3] Deploy budget alerts and notification rules using `modules/cost-management/budget-alerts/main.bicep`

## Human Approval Required ⚠️
Review budget limits and cost policies before activation

## Independent Test Criteria 📋
Setup budgets, verify alerts work, test cost tracking capabilities

## Priority
**P3** - Medium Priority User Story

## Parallel Execution Opportunities
Tasks T048-T049 can run in parallel (marked with [P])

## Dependencies
Independent of other user stories, can run in parallel with US2

## Estimated Effort
32 hours total (8 hours per task)

## Acceptance Criteria
- Hierarchical budget structure aligns with organizational structure
- Department and project budgets are properly configured
- Budget alerts notify finance teams at appropriate thresholds
- Cost tracking enables accurate chargeback and allocation
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US3-P3] Cost Optimization and Reporting (T051-T053)" `
    -Labels @("user-story-3", "p3-priority", "cost-optimization", "reporting", "chargeback") `
    -Body @"
## User Story 3: Cost Management and Resource Governance (Priority P3)
Implement automated cost optimization and comprehensive reporting capabilities

## Tasks
- [ ] **T051** [US3] Create resource right-sizing policies in `modules/cost-management/optimization/rightsizing-policies.bicep`
- [ ] **T052** [US3] Setup automated cost reporting in `modules/cost-management/reporting/cost-reports.bicep`
- [ ] **T053** [US3] Configure cost allocation and chargeback model in `modules/cost-management/chargeback/main.bicep`

## Priority
**P3** - Medium Priority User Story

## Dependencies
- Issue: Budget Management and Hierarchy (T047-T050)

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- Right-sizing policies optimize resource utilization
- Automated cost reports provide regular insights
- Chargeback model enables accurate cost allocation
- Cost optimization recommendations are actionable
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US3-P3] Resource Tagging and Cost Tracking (T054-T056)" `
    -Labels @("user-story-3", "p3-priority", "tagging", "cost-tracking", "automation") `
    -Body @"
## User Story 3: Cost Management and Resource Governance (Priority P3)
Automated resource tagging for comprehensive cost tracking and allocation

## Tasks
- [ ] **T054** [P] [US3] Create cost center tagging automation in `modules/governance/tagging/cost-center-tags.bicep`
- [ ] **T055** [P] [US3] Create project tagging automation in `modules/governance/tagging/project-tags.bicep`
- [ ] **T056** [US3] Deploy automated tagging policies for cost tracking

## Priority
**P3** - Medium Priority User Story

## Parallel Execution Opportunities
Tasks T054-T055 can run in parallel (marked with [P])

## Dependencies
- Issue: Cost Optimization and Reporting (T051-T053)

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- Cost center tagging is automatically applied to all resources
- Project tagging enables granular cost tracking
- Tagging policies enforce consistent cost allocation
- Cost reports utilize tagging for accurate attribution
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US3-P3] Cost Management Testing and Validation (T057-T059)" `
    -Labels @("user-story-3", "p3-priority", "testing", "validation", "cost-management") `
    -Body @"
## User Story 3: Cost Management and Resource Governance (Priority P3)
Comprehensive testing of cost management capabilities and optimization features

## Tasks
- [ ] **T057** [US3] Test budget alert notifications to finance teams in `scripts/Test-BudgetAlerts.ps1`
- [ ] **T058** [US3] Test automated resource tagging for cost allocation in `scripts/Test-CostTagging.ps1`
- [ ] **T059** [US3] Test cost reporting and optimization recommendations in `scripts/Test-CostOptimization.ps1`

## Priority
**P3** - Medium Priority User Story

## Dependencies
- Issue: Resource Tagging and Cost Tracking (T054-T056)

## Human Approval Required ⚠️
Validate cost management capabilities

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- Budget alerts are delivered to finance teams accurately
- Automated tagging correctly attributes costs
- Cost reports provide actionable optimization insights
- End-to-end cost management workflow is validated
"@

# ==============================================================================
# Phase 6: User Story 4 - Network Security and Connectivity (Priority P4)
# ==============================================================================

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US4-P4] Network Foundation and Hub-Spoke Architecture (T060-T063)" `
    -Labels @("user-story-4", "p4-priority", "networking", "hub-spoke", "disaster-recovery") `
    -Body @"
## User Story 4: Network Security and Connectivity (Priority P4)
Establish secure network architecture and connectivity patterns

## Tasks
- [ ] **T060** [US4] Create hub virtual network configuration in `modules/networking/hub-vnet/main.bicep`
- [ ] **T061** [US4] Create spoke virtual network templates in `modules/networking/spoke-vnet/main.bicep`
- [ ] **T062** [US4] Deploy primary region network (West Europe) using hub-spoke pattern
- [ ] **T063** [US4] Deploy secondary region network (North Europe) for disaster recovery

## Human Approval Required ⚠️
Review network security configurations before deployment

## Independent Test Criteria 📋
Configure network policies, test segmentation, verify security controls

## Priority
**P4** - Medium Priority User Story

## Dependencies
Independent of other user stories, can run in parallel with US2-US3

## Estimated Effort
32 hours total (8 hours per task)

## Acceptance Criteria
- Hub-spoke network architecture is deployed in both regions
- Primary region (West Europe) is operational
- Secondary region (North Europe) supports disaster recovery
- Network foundation supports secure workload deployment
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US4-P4] Network Security Controls (T064-T067)" `
    -Labels @("user-story-4", "p4-priority", "security", "firewall", "nsg", "access-control") `
    -Body @"
## User Story 4: Network Security and Connectivity (Priority P4)
Implement comprehensive network security controls and Azure Firewall

## Tasks
- [ ] **T064** [P] [US4] Create network security group rules in `modules/networking/security/nsg-rules.bicep`
- [ ] **T065** [P] [US4] Create Azure Firewall configuration in `modules/networking/firewall/main.bicep`
- [ ] **T066** [P] [US4] Create network access control policies in `modules/networking/security/access-policies.bicep`
- [ ] **T067** [US4] Deploy Azure Firewall with FSI-compliant security rules

## Priority
**P4** - Medium Priority User Story

## Parallel Execution Opportunities
Tasks T064-T066 can run in parallel (marked with [P])

## Dependencies
- Issue: Network Foundation and Hub-Spoke Architecture (T060-T063)

## Estimated Effort
32 hours total (8 hours per task)

## Acceptance Criteria
- Network security groups enforce proper segmentation
- Azure Firewall provides centralized security control
- Access control policies meet FSI compliance requirements
- Security rules protect financial workloads appropriately
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US4-P4] Secure Connectivity and Monitoring (T068-T070)" `
    -Labels @("user-story-4", "p4-priority", "connectivity", "monitoring", "segmentation") `
    -Body @"
## User Story 4: Network Security and Connectivity (Priority P4)
Configure secure connectivity patterns and comprehensive network monitoring

## Tasks
- [ ] **T068** [US4] Configure secure connectivity for financial workloads in `modules/networking/connectivity/financial-workloads.bicep`
- [ ] **T069** [US4] Setup network monitoring and flow logs in `modules/networking/monitoring/network-monitoring.bicep`
- [ ] **T070** [US4] Deploy network segmentation for compliance isolation

## Priority
**P4** - Medium Priority User Story

## Dependencies
- Issue: Network Security Controls (T064-T067)

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- Financial workloads have secure, isolated connectivity
- Network monitoring captures all traffic flows
- Compliance isolation is enforced through segmentation
- Network visibility supports security operations
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US4-P4] Network Testing and Validation (T071-T073)" `
    -Labels @("user-story-4", "p4-priority", "testing", "validation", "networking") `
    -Body @"
## User Story 4: Network Security and Connectivity (Priority P4)
Comprehensive testing of network security, connectivity, and disaster recovery capabilities

## Tasks
- [ ] **T071** [US4] Test network segmentation and access controls in `scripts/Test-NetworkSecurity.ps1`
- [ ] **T072** [US4] Test firewall rules and traffic monitoring in `scripts/Test-FirewallRules.ps1`
- [ ] **T073** [US4] Test cross-region connectivity and failover in `scripts/Test-NetworkConnectivity.ps1`

## Priority
**P4** - Medium Priority User Story

## Dependencies
- Issue: Secure Connectivity and Monitoring (T068-T070)

## Human Approval Required ⚠️
Validate network security and connectivity

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- Network segmentation prevents unauthorized access
- Firewall rules correctly filter and log traffic
- Cross-region connectivity supports disaster recovery
- Network security controls are validated end-to-end
"@

# ==============================================================================
# Phase 7: User Story 5 - Monitoring and Operational Visibility (Priority P5)
# ==============================================================================

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US5-P5] Monitoring Infrastructure and Log Analytics (T074-T076)" `
    -Labels @("user-story-5", "p5-priority", "monitoring", "log-analytics", "retention") `
    -Body @"
## User Story 5: Monitoring and Operational Visibility (Priority P5)
Implement comprehensive monitoring, alerting, and operational dashboards

## Tasks
- [ ] **T074** [US5] Create Log Analytics workspace configuration in `modules/monitoring/log-analytics/main.bicep`
- [ ] **T075** [US5] Deploy Azure Monitor for comprehensive telemetry collection
- [ ] **T076** [US5] Configure 7-year log retention for audit compliance in `modules/monitoring/retention/audit-retention.bicep`

## Human Approval Required ⚠️
Review monitoring configurations and alert thresholds

## Independent Test Criteria 📋
Setup monitoring, configure alerts, verify operational dashboards work

## Priority
**P5** - Lower Priority User Story

## Dependencies
- US1 (Identity) for authentication, can overlap with other user stories

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- Log Analytics workspace captures comprehensive telemetry
- Azure Monitor provides full visibility across all resources
- 7-year retention meets regulatory compliance requirements
- Monitoring foundation supports operational excellence
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US5-P5] Security Monitoring and Threat Detection (T077-T079)" `
    -Labels @("user-story-5", "p5-priority", "security-monitoring", "defender", "sentinel") `
    -Body @"
## User Story 5: Monitoring and Operational Visibility (Priority P5)
Deploy advanced security monitoring and threat detection capabilities

## Tasks
- [ ] **T077** [P] [US5] Create Microsoft Defender for Cloud configuration in `modules/security/defender/main.bicep`
- [ ] **T078** [P] [US5] Create Azure Sentinel security monitoring in `modules/security/sentinel/main.bicep`
- [ ] **T079** [US5] Deploy security monitoring and threat detection capabilities

## Priority
**P5** - Lower Priority User Story

## Parallel Execution Opportunities
Tasks T077-T078 can run in parallel (marked with [P])

## Dependencies
- Issue: Monitoring Infrastructure and Log Analytics (T074-T076)

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- Microsoft Defender for Cloud provides security recommendations
- Azure Sentinel enables advanced threat detection
- Security monitoring covers all critical assets
- Threat detection capabilities are tuned for financial services
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US5-P5] Operational Dashboards (T080-T083)" `
    -Labels @("user-story-5", "p5-priority", "dashboards", "operations", "alerts") `
    -Body @"
## User Story 5: Monitoring and Operational Visibility (Priority P5)
Create comprehensive operational dashboards and automated alerting

## Tasks
- [ ] **T080** [P] [US5] Create operational health dashboard in `modules/monitoring/dashboards/operational-health.bicep`
- [ ] **T081** [P] [US5] Create compliance monitoring dashboard in `modules/monitoring/dashboards/compliance-dashboard.bicep`
- [ ] **T082** [P] [US5] Create cost optimization dashboard in `modules/monitoring/dashboards/cost-dashboard.bicep`
- [ ] **T083** [US5] Deploy automated alerting for critical system thresholds

## Priority
**P5** - Lower Priority User Story

## Parallel Execution Opportunities
Tasks T080-T082 can run in parallel (marked with [P])

## Dependencies
- Issue: Security Monitoring and Threat Detection (T077-T079)

## Estimated Effort
32 hours total (8 hours per task)

## Acceptance Criteria
- Operational health dashboard provides real-time system status
- Compliance dashboard tracks regulatory adherence
- Cost optimization dashboard enables financial oversight
- Automated alerting ensures rapid incident response
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US5-P5] Alert Management and SLA Monitoring (T084-T085)" `
    -Labels @("user-story-5", "p5-priority", "alerts", "sla", "notifications") `
    -Body @"
## User Story 5: Monitoring and Operational Visibility (Priority P5)
Configure alert management and SLA monitoring for 99.9% uptime target

## Tasks
- [ ] **T084** [US5] Configure alert rules for 99.9% uptime SLA in `modules/monitoring/alerts/sla-alerts.bicep`
- [ ] **T085** [US5] Setup notification groups for different operational scenarios in `modules/monitoring/notifications/main.bicep`

## Priority
**P5** - Lower Priority User Story

## Dependencies
- Issue: Operational Dashboards (T080-T083)

## Estimated Effort
16 hours total (8 hours per task)

## Acceptance Criteria
- Alert rules support 99.9% uptime SLA monitoring
- Notification groups ensure appropriate escalation
- Alert fatigue is minimized through intelligent rules
- SLA monitoring provides actionable insights
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[US5-P5] Monitoring Testing and Validation (T086-T088)" `
    -Labels @("user-story-5", "p5-priority", "testing", "validation", "monitoring") `
    -Body @"
## User Story 5: Monitoring and Operational Visibility (Priority P5)
Comprehensive testing of monitoring, alerting, and security detection capabilities

## Tasks
- [ ] **T086** [US5] Test monitoring data collection and dashboard visibility in `scripts/Test-Monitoring.ps1`
- [ ] **T087** [US5] Test alert notifications for critical thresholds in `scripts/Test-AlertNotifications.ps1`
- [ ] **T088** [US5] Test security event detection and response in `scripts/Test-SecurityMonitoring.ps1`

## Priority
**P5** - Lower Priority User Story

## Dependencies
- Issue: Alert Management and SLA Monitoring (T084-T085)

## Human Approval Required ⚠️
Validate monitoring and alerting capabilities

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- Monitoring data collection is comprehensive and accurate
- Alert notifications reach appropriate stakeholders
- Security event detection triggers proper responses
- End-to-end monitoring workflow is validated
"@

# ==============================================================================
# Phase 8: Integration and Polish
# ==============================================================================

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[Integration] End-to-End Testing and Validation (T089-T091)" `
    -Labels @("integration", "high-priority", "testing", "disaster-recovery", "compliance") `
    -Body @"
## Phase 8: Integration and Polish
Cross-cutting concerns, end-to-end testing, and final integration

## Tasks
- [ ] **T089** Create end-to-end integration test suite in `scripts/Test-EndToEnd.ps1`
- [ ] **T090** [P] Create disaster recovery validation in `scripts/Test-DisasterRecovery.ps1`
- [ ] **T091** [P] Create compliance validation test suite in `scripts/Test-ComplianceValidation.ps1`

## Human Approval Required ⚠️
Final review before production deployment

## Priority
**High** - Critical for production readiness

## Parallel Execution Opportunities
Tasks T090-T091 can run in parallel (marked with [P])

## Dependencies
- All User Stories (US1-US5) must be completed

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- End-to-end integration test suite validates all components
- Disaster recovery procedures are tested and functional
- Compliance validation confirms regulatory adherence
- System is ready for production deployment
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[Integration] Documentation and Operational Handover (T092-T094)" `
    -Labels @("integration", "medium-priority", "documentation", "operations", "security") `
    -Body @"
## Phase 8: Integration and Polish
Comprehensive documentation and operational procedures for production handover

## Tasks
- [ ] **T092** [P] Create operational runbook documentation in `docs/operations/runbook.md`
- [ ] **T093** [P] Create incident response procedures in `docs/security/incident-response.md`
- [ ] **T094** Create final deployment guide in `docs/deployment/production-deployment.md`

## Priority
**Medium** - Essential for operational success

## Parallel Execution Opportunities
Tasks T092-T093 can run in parallel (marked with [P])

## Dependencies
- Issue: End-to-End Testing and Validation (T089-T091)

## Estimated Effort
24 hours total (8 hours per task)

## Acceptance Criteria
- Operational runbook provides complete operational guidance
- Incident response procedures are comprehensive and tested
- Deployment guide enables consistent production deployments
- Documentation supports operational excellence
"@

New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf `
    -Title "[Integration] Production Readiness and Security Review (T095-T096)" `
    -Labels @("integration", "critical-priority", "production", "security", "review") `
    -Body @"
## Phase 8: Integration and Polish
Final production readiness validation and security review

## Tasks
- [ ] **T095** Create production environment validation in `scripts/Test-ProductionReadiness.ps1`
- [ ] **T096** Final security review and sign-off checklist in `docs/security/security-review-checklist.md`

## Priority
**Critical** - Gate to production deployment

## Dependencies
- Issue: Documentation and Operational Handover (T092-T094)

## Human Approval Required ⚠️
Final security review and production sign-off

## Estimated Effort
16 hours total (8 hours per task)

## Acceptance Criteria
- Production environment validation confirms readiness
- Security review checklist is complete with all sign-offs
- All components are validated for production deployment
- Toyota Louwmans FS Azure Cloud Foundation is production-ready
"@

Write-Host ""
Write-Host "Summary:" -ForegroundColor Green
Write-Host "- Total Issues Created: $issueCount" -ForegroundColor Yellow
Write-Host "- Total Tasks Covered: 98" -ForegroundColor Yellow
Write-Host "- Phases: 8 (Setup → Foundation → US1-US5 → Integration)" -ForegroundColor Yellow
Write-Host "- Priorities: P1 (Highest) → P5 (Lowest)" -ForegroundColor Yellow
Write-Host "- Parallel Opportunities: Marked with [P] in task descriptions" -ForegroundColor Yellow
Write-Host "- Human Approval: Required at each issue completion" -ForegroundColor Yellow
Write-Host ""

if ($WhatIf) {
    Write-Host "WhatIf Mode Complete - No actual issues created" -ForegroundColor Cyan
    Write-Host "Run without -WhatIf to create actual GitHub issues" -ForegroundColor Cyan
} else {
    Write-Host "All GitHub issues created successfully!" -ForegroundColor Green
    Write-Host "Check your repository: https://github.com/$Repository/issues" -ForegroundColor Blue
}