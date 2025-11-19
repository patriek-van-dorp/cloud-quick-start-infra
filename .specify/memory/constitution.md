<!--
  Sync Impact Report:
  Version change: 1.0.0 → 1.1.0 (GitHub Flow mandate and branch governance expansion)
  Modified principles: 
    - DevSecOps Workflow → Enhanced with strict GitHub Flow requirements
    - Governance → Added explicit task-level branching requirements
  Added sections: 
    - GitHub Flow Process (mandatory for all tasks and issues)
    - Branch Strategy Standards with enforcement rules
  Removed sections: None
  Templates requiring updates: 
    ✅ plan-template.md - Updated Constitution Check with GitHub Flow compliance requirements
    ✅ tasks-template.md - Added GitHub Flow requirements and branching instructions
    ✅ spec-template.md - User scenarios align with iterative delivery principle (no changes needed)
    ✅ checklist-template.md - No changes needed for branching strategy
  Follow-up TODOs: None - all templates updated to enforce GitHub Flow requirements
-->

# Cloud Quick Start Infrastructure Constitution

## Core Principles

### I. Enterprise Scale Landing Zone Foundation (NON-NEGOTIABLE)
All infrastructure MUST follow Microsoft's Enterprise Scale Landing Zone patterns. Azure Verified Modules (AVM) are required for all deployments. Infrastructure as Code (IaC) using Bicep or Terraform is mandatory - no manual Azure portal configurations. Landing zones must implement proper subscription organization, management group hierarchies, and policy enforcement from day one.

**Rationale**: Ensures scalability, compliance, and alignment with Microsoft's proven enterprise patterns while preventing configuration drift and manual errors.

### II. Well-Architected Framework Compliance (NON-NEGOTIABLE)
Every solution MUST demonstrate compliance with Azure's Well-Architected Framework five pillars: Reliability, Security, Cost Optimization, Operational Excellence, and Performance Efficiency. Architecture decisions must be documented with explicit WAF pillar justification. Regular WAF assessments are mandatory for all workloads.

**Rationale**: Guarantees production-ready, secure, and cost-effective solutions that align with Microsoft's architectural best practices.

### III. Avanade Excellence Principles (NON-NEGOTIABLE)
All work must embody Avanade's core values: "Create the Future" through innovative cloud-native solutions, "Inspire Greatness" by delivering exceptional outcomes, and "Accelerate Impact" via proven accelerators and automation. Solutions must demonstrate clear business value and future readiness.

**Rationale**: Ensures alignment with Avanade's mission and commitment to client excellence while driving innovation and measurable impact.

### IV. DevSecOps-First Approach
Security must be integrated from the earliest design phases, not bolted on later. All infrastructure code requires automated security scanning, policy validation, and compliance checks. Every deployment pipeline must include security gates, vulnerability assessments, and compliance verification before production deployment.

**Rationale**: Prevents security technical debt, reduces risk exposure, and ensures regulatory compliance through proactive security practices.

### V. Small Iterations & Incremental Delivery
All features must be decomposable into small, independently testable, and deployable increments. Each iteration must deliver demonstrable business value. No feature should require more than 2-week implementation cycles. User feedback loops are mandatory between iterations.

**Rationale**: Reduces risk, enables faster feedback cycles, and ensures continuous value delivery while maintaining solution quality.

## Azure Architecture Standards

### Technology Stack Requirements
- **IaC Languages**: Bicep (preferred) or Terraform only - no ARM templates
- **Module Sources**: Azure Verified Modules (AVM) from official registries
- **Subscription Model**: Enterprise Scale Landing Zone subscription organization
- **Management**: Azure Policy for governance, Azure Monitor for observability
- **Security**: Microsoft Defender for Cloud, Azure Key Vault for secrets
- **Identity**: Azure Active Directory with proper RBAC implementation
- **Networking**: Hub-and-spoke or Virtual WAN architectures only

### Compliance & Security Standards
- All resources must be deployed within approved Azure regions
- Data residency requirements must be explicitly validated
- Encryption at rest and in transit is mandatory for all data
- Network security groups and Azure Firewall rules required for all traffic
- Regular security assessments using Microsoft Defender for Cloud
- Backup and disaster recovery plans required for all production workloads

### Performance & Cost Standards
- Cost budgets and alerts must be configured for all resource groups
- Auto-scaling policies required for compute resources
- Reserved instances or Azure Hybrid Benefit utilization where applicable
- Performance monitoring and alerting mandatory for all services
- Regular cost optimization reviews using Azure Advisor recommendations

## DevSecOps Workflow

### GitHub Flow Process (NON-NEGOTIABLE)
EVERY single task or GitHub Issue MUST be implemented on a separate branch created from the feature branch. This ensures atomic changes and enables proper code review. The mandatory workflow is:

1. **Feature Branch**: Create from main/default branch using naming convention `###-feature-name`
2. **Task Branch**: Create separate branch from feature branch for EACH individual task using `###-feature-name-taskID`
3. **Implementation**: Complete single task/issue on task branch with proper testing
4. **Review**: Submit pull request from task branch to feature branch (never directly to main)
5. **Merge**: Only merge to feature branch after passing all quality gates and reviews
6. **Integration**: Feature branch merges to main only when entire feature is complete

NO exceptions allowed. Manual changes, direct commits to feature branches, or skipping task-level branches violate this constitution and require architect approval with written justification.

### Branch Strategy Standards
- **Feature Branch Naming**: `###-feature-name` (where ### is 3-digit issue/spec number)
- **Task Branch Naming**: `###-feature-name-task##` (where ## is sequential task identifier)
- **Branch Protection**: Feature and main branches must have protection rules enabled
- **Merge Requirements**: Minimum 1 reviewer approval, all status checks must pass
- **Branch Cleanup**: Task branches deleted after successful merge to feature branch
- **Commit Standards**: Conventional commits format required, detailed task-specific messages

### Code Quality Gates
- All infrastructure code must pass automated linting and validation
- Peer review required for all infrastructure changes
- Security scanning (SAST/DAST) mandatory in all pipelines
- Compliance policy validation before any deployment
- Infrastructure tests (unit, integration, end-to-end) required

### Deployment Process
- Staged rollouts: Development → Test → Staging → Production
- Automated testing in dedicated test environments
- Rollback procedures documented and tested for all deployments
- Environment-specific configuration management through proper branching

### Change Management
- All changes must include impact assessment and rollback plan
- Architecture Decision Records (ADRs) for significant design choices
- Change approval process for production environment modifications
- Post-deployment validation and monitoring confirmation required
- Incident response procedures for infrastructure failures

## Governance

This constitution supersedes all other development practices and standards. All infrastructure deployments, architecture reviews, and technical decisions must demonstrate explicit compliance with these principles. Violations require written justification and architect approval before proceeding.

**GitHub Flow Enforcement**: Every pull request MUST demonstrate compliance with the mandatory GitHub Flow process. Task-level branching is non-negotiable - violations result in immediate PR rejection. All AI assistants and development tools must enforce these branching requirements in their guidance and code generation.

Amendment process requires proposal documentation, impact assessment, stakeholder review, and version increment following semantic versioning (MAJOR for principle changes, MINOR for new sections, PATCH for clarifications).

All pull requests must include constitution compliance verification. Complexity that violates the "Small Iterations" principle must be justified with clear decomposition strategy. Use Azure Well-Architected Review Tool for runtime architecture guidance and regular compliance validation.

**Version**: 1.1.0 | **Ratified**: 2025-11-18 | **Last Amended**: 2025-11-19
