# Data Model: Azure Cloud Foundation for Toyota Louwmans Financial Services

**Date**: November 18, 2025  
**Status**: Phase 1 Design Complete  
**Input**: Feature specification and research findings

## Overview

This document defines the core entities, relationships, and state transitions for the Azure Cloud Foundation. The data model ensures FSI compliance, complete isolation from parent company, and supports the governance requirements for Toyota Louwmans Financial Services.

## Core Entities

### 1. Tenant
**Description**: The isolated Azure environment for Toyota Louwmans Financial Services with distinct governance from parent company.

**Attributes**:
- `tenantId`: Unique Azure AD tenant identifier (GUID)
- `tenantName`: "Toyota Louwmans Financial Services"
- `domain`: Primary domain for the tenant (e.g., toyotalouwmansfs.onmicrosoft.com)
- `region`: Primary Azure region (West Europe)
- `secondaryRegion`: Secondary Azure region for DR (North Europe)
- `isolationLevel`: COMPLETE (no federation with parent company)
- `complianceFrameworks`: Array of applicable regulations [SOX, PCI_DSS, GDPR, FSI_LOCAL]
- `createdDate`: Tenant creation timestamp
- `lastAuditDate`: Most recent compliance audit timestamp

**Validation Rules**:
- Tenant must not have any federation with parent Toyota Louwmans tenant
- Primary region must support all required Azure services
- Compliance frameworks must include FSI mandatory regulations

### 2. Management Group
**Description**: Hierarchical governance container for subscriptions with inherited policies and RBAC.

**Attributes**:
- `managementGroupId`: Unique identifier within tenant
- `displayName`: Human-readable name
- `parentId`: Reference to parent management group (null for root)
- `level`: Hierarchy level (1=Root, 2=Platform/Landing-Zones, 3=Workload-specific)
- `subscriptions`: Array of subscription IDs under this management group
- `policies`: Array of policy assignment references
- `roleAssignments`: Array of RBAC assignments
- `budgetLimit`: Optional spending limit for all subscriptions

**Relationships**:
- Parent-child hierarchy with other Management Groups
- One-to-many with Subscriptions
- Many-to-many with Policies and Role Assignments

**State Transitions**:
- `CREATING` → `ACTIVE` → `DECOMMISSIONING` → `DELETED`
- Subscriptions must be moved before deletion
- Policies and RBAC automatically inherited by children

### 3. Subscription  
**Description**: Billing and administrative boundary within the tenant for resource organization.

**Attributes**:
- `subscriptionId`: Unique Azure subscription identifier (GUID)
- `displayName`: Human-readable subscription name
- `subscriptionType`: Enum [PRODUCTION, NON_PRODUCTION, SANDBOX]
- `workloadType`: Enum [PLATFORM, CORP, ONLINE, ANALYTICS, DEVOPS]
- `managementGroupId`: Reference to owning management group
- `costCenter`: Business unit allocation for chargeback
- `primaryRegion`: Primary deployment region
- `secondaryRegion`: Secondary region for DR resources
- `monthlyBudget`: Allocated monthly budget in EUR
- `currentSpend`: Current month spending
- `environment`: Enum [DEV, TEST, STAGING, PROD]

**Validation Rules**:
- Production subscriptions require secondary region for DR
- Monthly budget cannot exceed management group limit
- Cost center must be valid business unit code

**State Transitions**:
- `PENDING` → `ACTIVE` → `WARNING` → `DISABLED` → `DELETED`
- WARNING triggered at 80% budget consumption
- DISABLED triggered at 100% budget consumption

### 4. Identity Principal
**Description**: Users, service accounts, and applications requiring access to cloud resources.

**Attributes**:
- `principalId`: Unique object identifier in Azure AD
- `principalType`: Enum [USER, GROUP, SERVICE_PRINCIPAL, MANAGED_IDENTITY]
- `displayName`: Human-readable name
- `userPrincipalName`: UPN for user accounts
- `isExternal`: Boolean indicating external identity
- `securityClearance`: Enum [PUBLIC, INTERNAL, CONFIDENTIAL, RESTRICTED] 
- `department`: Business department assignment
- `lastLoginDate`: Most recent authentication timestamp
- `mfaEnabled`: Boolean indicating multi-factor authentication status
- `conditionalAccessPolicies`: Array of applicable CA policies

**Relationships**:
- Many-to-many with Role Assignments
- One-to-many with Resource Access requests
- Many-to-many with Security Groups

**State Transitions**:
- `PENDING_APPROVAL` → `ACTIVE` → `SUSPENDED` → `DELETED`
- Emergency access procedures allow temporary ELEVATED state

### 5. Policy
**Description**: Governance rules that enforce compliance, security, and operational requirements.

**Attributes**:
- `policyId`: Unique policy identifier
- `name`: Policy name (max 24 chars for management group scope)
- `displayName`: Human-readable policy name  
- `policyType`: Enum [BUILTIN, CUSTOM, INITIATIVE]
- `category`: Enum [SECURITY, COMPLIANCE, COST, OPERATIONAL]
- `effect`: Enum [DENY, AUDIT, APPEND, MODIFY, DISABLED]
- `scope`: Assignment scope (management group, subscription, resource group)
- `parameters`: Policy configuration parameters object
- `complianceState`: Enum [COMPLIANT, NON_COMPLIANT, UNKNOWN]
- `lastEvaluation`: Most recent compliance evaluation timestamp

**Validation Rules**:
- Custom policies require security review approval
- Deny policies require impact assessment
- Compliance policies cannot be disabled in production

### 6. Resource Group
**Description**: Logical containers for related resources with consistent lifecycle and permissions.

**Attributes**:
- `resourceGroupId`: Unique resource group identifier
- `name`: Resource group name (must follow naming convention)
- `subscriptionId`: Reference to owning subscription
- `location`: Azure region for resource group metadata
- `environment`: Enum [DEV, TEST, STAGING, PROD]
- `workload`: Business workload or application name
- `costCenter`: Cost allocation for chargeback
- `owner`: Responsible team or individual
- `tags`: Key-value pairs for resource organization
- `resourceCount`: Number of resources in the group

**Relationships**:
- Many-to-one with Subscription
- One-to-many with Azure Resources
- Many-to-many with Role Assignments

**Validation Rules**:
- Name must follow pattern: `rg-{workload}-{environment}-{region}-{001}`
- Must have required tags: environment, workload, costCenter, owner
- Production resource groups require backup and monitoring

### 7. Cost Center
**Description**: Business unit or department allocation for cost tracking and chargeback.

**Attributes**:
- `costCenterId`: Unique business identifier
- `name`: Cost center name
- `department`: Business department
- `manager`: Responsible manager
- `annualBudget`: Total annual budget allocation in EUR
- `currentSpend`: Year-to-date spending
- `monthlyAllocation`: Array of monthly budget distributions
- `chargebackModel`: Enum [DIRECT, SHARED, ALLOCATED]
- `approvers`: Array of budget approval authorities

**Relationships**:
- One-to-many with Subscriptions
- One-to-many with Resource Groups
- Many-to-many with Budget Alerts

### 8. Compliance Control
**Description**: Specific regulatory requirement with associated monitoring and enforcement.

**Attributes**:
- `controlId`: Unique compliance control identifier
- `framework`: Enum [SOX, PCI_DSS, GDPR, ISO_27001, FSI_LOCAL]
- `title`: Control title/description
- `requirement`: Detailed requirement text
- `implementation`: Technical implementation approach
- `evidence`: Array of compliance evidence artifacts
- `testFrequency`: Enum [CONTINUOUS, DAILY, WEEKLY, MONTHLY, QUARTERLY]
- `lastTest`: Most recent compliance test timestamp
- `status`: Enum [COMPLIANT, NON_COMPLIANT, REMEDIATION, NOT_TESTED]
- `owner`: Control owner/responsible party

**Validation Rules**:
- Critical controls require continuous monitoring
- Non-compliant status requires remediation plan
- Evidence must be retained for 7 years (FSI requirement)

### 9. Security Event
**Description**: Any action or occurrence that may impact the security posture of the environment.

**Attributes**:
- `eventId`: Unique security event identifier
- `timestamp`: Event occurrence time (UTC)
- `eventType`: Enum [LOGIN, POLICY_VIOLATION, RESOURCE_CHANGE, PRIVILEGED_ACCESS, THREAT_DETECTED]
- `severity`: Enum [LOW, MEDIUM, HIGH, CRITICAL]
- `source`: Event source (Azure service, application, user)
- `principalId`: Associated identity principal
- `resourceId`: Affected resource (if applicable)
- `details`: Event-specific details object
- `status`: Enum [OPEN, INVESTIGATING, RESOLVED, CLOSED]
- `assignedTo`: Security team member handling event

**Relationships**:
- Many-to-one with Identity Principal
- Many-to-one with Azure Resource
- One-to-many with Remediation Actions

**State Transitions**:
- `DETECTED` → `OPEN` → `INVESTIGATING` → `RESOLVED` → `CLOSED`
- Critical events auto-escalate to security operations center

## Entity Relationships

### Hierarchical Relationships
```
Tenant
├── Management Groups (hierarchical)
│   └── Subscriptions
│       └── Resource Groups
│           └── Azure Resources
```

### Cross-Cutting Relationships  
```
Identity Principals ←→ Role Assignments ←→ Scopes (MG/Sub/RG/Resource)
Policies ←→ Policy Assignments ←→ Scopes (MG/Sub/RG/Resource)
Cost Centers ←→ Subscriptions ←→ Resource Groups
Compliance Controls ←→ Resources ←→ Evidence
Security Events ←→ Principals ←→ Resources
```

### Data Flow Patterns

#### Cost Allocation Flow
1. Resource consumption generates billing data
2. Billing data aggregated by Resource Group tags
3. Resource Group costs allocated to Cost Centers
4. Cost Centers generate chargeback reports
5. Budget alerts triggered on threshold breaches

#### Compliance Monitoring Flow
1. Resources configured with compliance policies
2. Policy evaluation generates compliance events
3. Non-compliant events trigger security events
4. Security events require remediation actions
5. Remediation actions update compliance status

#### Identity Access Flow
1. Principal requests resource access
2. Conditional access policies evaluate request
3. RBAC assignments determine permissions
4. Access granted/denied based on policy evaluation
5. Security events logged for audit trail

## Validation Rules Summary

### Data Integrity
- All GUIDs must be valid Azure resource identifiers
- Hierarchical relationships must maintain proper parent-child dependencies
- State transitions must follow defined state machines
- Timestamps must be in UTC format

### Business Rules
- FSI compliance controls cannot be disabled
- Production environments require DR configurations
- Budget limits enforce automatic resource management
- Security clearance levels determine data access permissions

### Compliance Requirements
- All administrative actions must generate audit trails
- Sensitive data must remain within EU regions (GDPR)
- Financial data requires encryption at rest and in transit
- Emergency access requires post-incident review and approval