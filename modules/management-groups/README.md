# Management Groups Module

## Overview

This Bicep module creates an 8-level Enterprise Scale Landing Zone management group hierarchy for Toyota Louwmans Financial Services. The hierarchy provides complete organizational isolation from the parent company with FSI compliance governance boundaries.

## Architecture

The module creates the following management group hierarchy:

```
Root Tenant Management Group
└── Toyota-Louwmans-Financial (TLFS-ROOT)
    ├── Platform (TLFS-PLATFORM)
    │   ├── Identity (TLFS-IDENTITY)
    │   ├── Connectivity (TLFS-CONNECTIVITY)
    │   └── Management (TLFS-MANAGEMENT)
    ├── Landing-Zones (TLFS-LANDINGZONES)
    │   ├── Corp (TLFS-CORP)
    │   └── Online (TLFS-ONLINE)
    ├── Sandbox (TLFS-SANDBOX)
    └── Decommissioned (TLFS-DECOMMISSIONED)
```

### Management Group Purposes

| Management Group | Level | Purpose | Compliance Requirements |
|-----------------|-------|---------|------------------------|
| **TLFS-ROOT** | 1 | Organizational root with complete isolation | FSI, SOX, GDPR, PCI-DSS |
| **TLFS-PLATFORM** | 2 | Shared platform services | SOX, GDPR |
| **TLFS-IDENTITY** | 3 | Azure AD Domain Services, identity governance | SOX, GDPR, Enhanced monitoring |
| **TLFS-CONNECTIVITY** | 3 | Hub networking, VPN, ExpressRoute, DNS | SOX, GDPR, DDoS Protection |
| **TLFS-MANAGEMENT** | 3 | Monitoring, backup, automation | SOX, GDPR, 7-year retention |
| **TLFS-LANDINGZONES** | 2 | Application landing zones | FSI, SOX, GDPR, PCI-DSS |
| **TLFS-CORP** | 3 | Corporate workloads with on-prem connectivity | FSI, SOX, GDPR, PCI-DSS |
| **TLFS-ONLINE** | 3 | Internet-facing applications | FSI, SOX, GDPR, PCI-DSS |
| **TLFS-SANDBOX** | 2 | Innovation, PoCs, training | GDPR, Auto-cleanup |
| **TLFS-DECOMMISSIONED** | 2 | Resources pending deletion | SOX, GDPR, Read-only |

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `managementGroupPrefix` | string | 'TLFS' | Prefix for all management group names |
| `rootMgDisplayName` | string | 'Toyota Louwmans Financial Services' | Display name for root management group |
| `parentManagementGroupId` | string | '' | Optional parent management group ID |
| `location` | string | `deployment().location` | Location for metadata storage |
| `tags` | object | See defaults | Common tags for all management groups |

## Outputs

| Output | Type | Description |
|--------|------|-------------|
| `rootManagementGroupId` | string | Resource ID of the root management group |
| `rootManagementGroupName` | string | Name of the root management group |
| `platformManagementGroups` | object | Resource IDs of all platform management groups |
| `landingZoneManagementGroups` | object | Resource IDs of all landing zone management groups |
| `supportingManagementGroups` | object | Resource IDs of sandbox and decommissioned management groups |
| `managementGroupHierarchy` | object | Complete hierarchy structure with levels |
| `managementGroupNames` | object | All management group names for reference |
| `complianceConfiguration` | object | FSI compliance settings for each management group |

## Usage Examples

### Basic Deployment

```bicep
module managementGroups './modules/management-groups/main.bicep' = {
  name: 'deploy-management-groups'
  scope: tenant()
  params: {
    managementGroupPrefix: 'TLFS'
    rootMgDisplayName: 'Toyota Louwmans Financial Services'
  }
}
```

### Custom Configuration

```bicep
module managementGroups './modules/management-groups/main.bicep' = {
  name: 'deploy-management-groups'
  scope: tenant()
  params: {
    managementGroupPrefix: 'TLFS'
    rootMgDisplayName: 'Toyota Louwmans Financial Services'
    tags: {
      Organization: 'Toyota Louwmans Financial Services'
      Environment: 'Production'
      CostCenter: 'IT-Infrastructure'
      Owner: 'Azure Administrators'
      ComplianceFramework: 'FSI-SOX-GDPR-PCI'
    }
  }
}
```

### Referencing Outputs

```bicep
// Reference management group IDs in other modules
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'fsi-compliance-policy'
  scope: managementGroups.outputs.rootManagementGroupId
  properties: {
    // Policy assignment properties
  }
}

// Use in subscription vending
module subscriptionVending './modules/subscriptions/main.bicep' = {
  name: 'vend-corp-subscription'
  params: {
    managementGroupId: managementGroups.outputs.landingZoneManagementGroups.corp
    subscriptionName: 'Prod-Corp-Financial-Systems'
  }
}
```

## FSI Compliance Features

### Organizational Isolation
- Complete separation from Toyota Motor Corporation
- Independent governance boundaries
- Isolated policy enforcement

### Regulatory Compliance
- **SOX (Sarbanes-Oxley)**: Segregation of duties, audit trails
- **GDPR**: EU data residency, privacy by design
- **PCI DSS**: Payment card data isolation
- **FSI Regulations**: Financial services industry compliance

### Audit and Retention
- 7-year audit log retention for financial services
- Immutable audit trails for all administrative actions
- Compliance reporting and monitoring

### Security Controls
- Enhanced monitoring for privileged access
- Network segmentation requirements
- Mandatory encryption at rest and in transit

## Dependencies

- Azure Tenant with appropriate permissions
- Management Group Contributor role at tenant root scope
- Azure CLI or Azure PowerShell for deployment

## Deployment Scope

This module must be deployed at **tenant scope** using:

```bash
# Azure CLI
az deployment tenant create \
  --template-file ./modules/management-groups/main.bicep \
  --location "West Europe" \
  --parameters managementGroupPrefix="TLFS"

# Azure PowerShell
New-AzTenantDeployment \
  -TemplateFile "./modules/management-groups/main.bicep" \
  -Location "West Europe" \
  -managementGroupPrefix "TLFS"
```

## Testing

After deployment, validate the hierarchy using:

```powershell
# Test script location
./scripts/powershell/Test-ManagementGroups.ps1

# Manual validation
Get-AzManagementGroup -GroupId "TLFS-ROOT" -Expand -Recurse
```

## Related Modules

- `modules/subscriptions/main.bicep` - Subscription vending for the hierarchy
- `modules/governance/policies/` - Policy assignments for compliance
- `modules/identity/rbac/` - RBAC role assignments

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-11-20 | Initial implementation with 8-level hierarchy |

## Support

For questions or issues with this module, contact:
- **Team**: Azure Infrastructure Team
- **Email**: azure-support@toyotalouwmansfs.com
- **Documentation**: See `docs/operations/runbook.md`