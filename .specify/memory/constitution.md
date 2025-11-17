<!--
Sync Impact Report:
- Version change: Initial → 1.0.0
- Added principles: Enterprise Scale Foundation, Well-Architected Framework Compliance, Security & Governance First, Avanade Value Acceleration, Infrastructure as Code
- Added sections: Microsoft Framework Compliance, Avanade Value Delivery
- Templates requiring updates: ✅ constitution updated
- Follow-up TODOs: None
-->

# Cloud Quick Start Infrastructure Constitution

## Core Principles

### I. Enterprise Scale Foundation (NON-NEGOTIABLE)
All cloud infrastructure MUST be based on Microsoft Enterprise Scale Landing Zone patterns with minimal viable implementation. Architecture decisions MUST align with the Hub & Spoke network topology, centralized identity management, and subscription organization strategies. No custom patterns that deviate from Enterprise Scale principles are permitted without explicit architectural review and documented justification.

**Rationale**: Enterprise Scale provides battle-tested, Microsoft-supported patterns that ensure scalability, security, and supportability. Deviations create technical debt and reduce Avanade's ability to leverage proven accelerators.

### II. Well-Architected Framework Compliance
Every infrastructure component MUST be designed and validated against all five WAF pillars: Security, Cost Optimization, Operational Excellence, Performance Efficiency, and Reliability. All architecture decisions MUST include WAF assessment documentation. Cost optimization MUST be built-in, not retrofitted.

**Rationale**: WAF compliance ensures infrastructure meets enterprise standards and provides clear decision frameworks. Early cost optimization prevents budget overruns and demonstrates value-conscious delivery.

### III. Security & Governance First
Security and governance controls MUST be implemented before any workload deployment. This includes: Zero Trust network design, Azure Policy enforcement, role-based access control (RBAC), resource tagging strategy, and compliance monitoring. All resources MUST be deployed through approved governance frameworks.

**Rationale**: Security cannot be an afterthought in cloud deployments. Early governance implementation prevents costly remediation and ensures compliance from day one.

### IV. Avanade Value Acceleration
Every implementation MUST highlight unique Avanade capabilities and accelerators. Leverage Avanade's proven assets including: deployment accelerators, monitoring solutions, security frameworks, and automation tools. Document how Avanade adds value beyond basic Microsoft services.

**Rationale**: Positions Avanade as a strategic partner, not just an implementer. Demonstrates our unique IP and differentiated capabilities to drive client success faster than alternatives.

### V. Infrastructure as Code (IaC) Excellence
All infrastructure MUST be deployed via code using Bicep (preferred) or ARM templates. No manual portal deployments except for initial proof-of-concept validation. Version control, code review, and automated testing are mandatory for all IaC. Environment parity MUST be maintained through parameterized templates.

**Rationale**: IaC ensures repeatability, auditability, and scalability. Manual deployments create configuration drift and operational risks that undermine enterprise reliability.

## Microsoft Framework Compliance

All implementations MUST adhere to Microsoft Cloud Adoption Framework phases: Strategy, Plan, Ready, Adopt, Govern, and Manage. Landing Zone deployments MUST follow the conceptual architecture with management groups, subscriptions, networking, identity, and policy structure. Regular compliance validation against Azure Security Benchmark is required.

**Technology Requirements**: Azure Resource Manager, Azure Policy, Azure Monitor, Microsoft Entra ID integration, Azure Key Vault for secrets management, and Azure Cost Management integration.

## Avanade Value Delivery

Every project MUST demonstrate Avanade's "Create the Future" principle by leveraging cutting-edge Azure services and preview features where appropriate. "Inspire Greatness" MUST be evident through knowledge transfer, best practices documentation, and capability building with client teams. "Accelerate Impact" MUST be quantified through delivery timelines, cost savings, and operational efficiency metrics.

**Value Demonstration**: Include ROI calculations, time-to-value metrics, and comparison with alternative approaches. Document reusable components and accelerators created for future client engagements.

## Governance

This constitution supersedes all other development practices and serves as the definitive guide for cloud infrastructure decisions. All architecture reviews, code reviews, and deployments MUST verify compliance with these principles. Amendments require formal architectural review, impact assessment, and version increment.

**Compliance Verification**: All pull requests MUST include constitution compliance checklist. Infrastructure deployments MUST pass automated policy validation. Regular architecture reviews MUST validate ongoing adherence.

**Version**: 1.0.0 | **Ratified**: 2025-11-17 | **Last Amended**: 2025-11-17
