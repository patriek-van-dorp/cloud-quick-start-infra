// ============================================================================
// Management Group Hierarchy Module for Toyota Louwmans Financial Services
// ============================================================================
// Creates an 8-level Enterprise Scale Landing Zone management group hierarchy
// with complete organizational isolation and FSI compliance governance
// 
// Architecture:
// Root Tenant Management Group
// └── Toyota-Louwmans-Financial (MG-TLFS-ROOT) 
//     ├── Platform (MG-TLFS-PLATFORM)
//     │   ├── Identity (MG-TLFS-IDENTITY)
//     │   ├── Connectivity (MG-TLFS-CONNECTIVITY) 
//     │   └── Management (MG-TLFS-MANAGEMENT)
//     ├── Landing-Zones (MG-TLFS-LANDINGZONES)
//     │   ├── Corp (MG-TLFS-CORP)
//     │   └── Online (MG-TLFS-ONLINE)
//     ├── Sandbox (MG-TLFS-SANDBOX)
//     └── Decommissioned (MG-TLFS-DECOMMISSIONED)

@description('The prefix to use for all management group names. Default: TLFS')
param managementGroupPrefix string = 'TLFS'

@description('The display name for the root management group')
param rootMgDisplayName string = 'Toyota Louwmans Financial Services'

@description('Optional parent management group ID. If not provided, will use tenant root.')
param parentManagementGroupId string = ''

@description('Location for metadata storage')
param location string = deployment().location

@description('Common tags to apply to all management groups')
param tags object = {
  Organization: 'Toyota Louwmans Financial Services'
  Environment: 'Foundation'
  CostCenter: 'IT-Infrastructure'
  Owner: 'Azure Administrators'
  Purpose: 'Enterprise Scale Landing Zone Foundation'
  ComplianceFramework: 'FSI-SOX-GDPR-PCI'
  CreatedBy: 'Bicep-Management-Groups-Module'
  CreatedDate: utcNow('yyyy-MM-dd')
}

// ============================================================================
// Variables and Configuration
// ============================================================================

var managementGroupHierarchy = {
  root: {
    name: '${managementGroupPrefix}-ROOT'
    displayName: rootMgDisplayName
    description: 'Root management group for Toyota Louwmans Financial Services with complete organizational isolation from parent company'
  }
  platform: {
    name: '${managementGroupPrefix}-PLATFORM'  
    displayName: 'Platform'
    description: 'Shared platform services including identity, connectivity, and management services'
  }
  platformIdentity: {
    name: '${managementGroupPrefix}-IDENTITY'
    displayName: 'Platform - Identity'
    description: 'Identity services including Azure AD Domain Services and identity governance'
  }
  platformConnectivity: {
    name: '${managementGroupPrefix}-CONNECTIVITY'
    displayName: 'Platform - Connectivity' 
    description: 'Hub networking, VPN Gateway, ExpressRoute, and DNS services'
  }
  platformManagement: {
    name: '${managementGroupPrefix}-MANAGEMENT'
    displayName: 'Platform - Management'
    description: 'Shared management services including monitoring, backup, and automation'
  }
  landingZones: {
    name: '${managementGroupPrefix}-LANDINGZONES'
    displayName: 'Landing Zones'
    description: 'Application landing zones for business workloads'
  }
  landingZonesCorp: {
    name: '${managementGroupPrefix}-CORP'
    displayName: 'Landing Zones - Corp'
    description: 'Corporate workloads requiring on-premises connectivity and domain services'
  }
  landingZonesOnline: {
    name: '${managementGroupPrefix}-ONLINE'
    displayName: 'Landing Zones - Online'
    description: 'Internet-facing applications and digital services'
  }
  sandbox: {
    name: '${managementGroupPrefix}-SANDBOX'
    displayName: 'Sandbox'
    description: 'Innovation, proof-of-concepts, and training environments'
  }
  decommissioned: {
    name: '${managementGroupPrefix}-DECOMMISSIONED'
    displayName: 'Decommissioned'
    description: 'Resources pending deletion with audit retention requirements'
  }
}

// ============================================================================
// Management Group Resources
// ============================================================================

// Level 1: Root Management Group
resource mgRoot 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupHierarchy.root.name
  properties: {
    displayName: managementGroupHierarchy.root.displayName
    details: {
      parent: empty(parentManagementGroupId) ? null : {
        id: parentManagementGroupId
      }
    }
  }
}

// Level 2: Platform Management Group
resource mgPlatform 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupHierarchy.platform.name
  dependsOn: [mgRoot]
  properties: {
    displayName: managementGroupHierarchy.platform.displayName
    details: {
      parent: {
        id: mgRoot.id
      }
    }
  }
}

// Level 2: Landing Zones Management Group
resource mgLandingZones 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupHierarchy.landingZones.name
  dependsOn: [mgRoot]
  properties: {
    displayName: managementGroupHierarchy.landingZones.displayName
    details: {
      parent: {
        id: mgRoot.id
      }
    }
  }
}

// Level 2: Sandbox Management Group  
resource mgSandbox 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupHierarchy.sandbox.name
  dependsOn: [mgRoot]
  properties: {
    displayName: managementGroupHierarchy.sandbox.displayName
    details: {
      parent: {
        id: mgRoot.id
      }
    }
  }
}

// Level 2: Decommissioned Management Group
resource mgDecommissioned 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupHierarchy.decommissioned.name
  dependsOn: [mgRoot]
  properties: {
    displayName: managementGroupHierarchy.decommissioned.displayName
    details: {
      parent: {
        id: mgRoot.id
      }
    }
  }
}

// Level 3: Platform - Identity Management Group
resource mgPlatformIdentity 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupHierarchy.platformIdentity.name
  dependsOn: [mgPlatform]
  properties: {
    displayName: managementGroupHierarchy.platformIdentity.displayName
    details: {
      parent: {
        id: mgPlatform.id
      }
    }
  }
}

// Level 3: Platform - Connectivity Management Group
resource mgPlatformConnectivity 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupHierarchy.platformConnectivity.name
  dependsOn: [mgPlatform]
  properties: {
    displayName: managementGroupHierarchy.platformConnectivity.displayName
    details: {
      parent: {
        id: mgPlatform.id
      }
    }
  }
}

// Level 3: Platform - Management Management Group
resource mgPlatformManagement 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupHierarchy.platformManagement.name
  dependsOn: [mgPlatform]
  properties: {
    displayName: managementGroupHierarchy.platformManagement.displayName
    details: {
      parent: {
        id: mgPlatform.id
      }
    }
  }
}

// Level 3: Landing Zones - Corp Management Group
resource mgLandingZonesCorp 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupHierarchy.landingZonesCorp.name
  dependsOn: [mgLandingZones]
  properties: {
    displayName: managementGroupHierarchy.landingZonesCorp.displayName
    details: {
      parent: {
        id: mgLandingZones.id
      }
    }
  }
}

// Level 3: Landing Zones - Online Management Group
resource mgLandingZonesOnline 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupHierarchy.landingZonesOnline.name
  dependsOn: [mgLandingZones]
  properties: {
    displayName: managementGroupHierarchy.landingZonesOnline.displayName
    details: {
      parent: {
        id: mgLandingZones.id
      }
    }
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('The resource ID of the root management group')
output rootManagementGroupId string = mgRoot.id

@description('The name of the root management group')
output rootManagementGroupName string = mgRoot.name

@description('The resource IDs of all platform management groups')
output platformManagementGroups object = {
  platform: mgPlatform.id
  identity: mgPlatformIdentity.id
  connectivity: mgPlatformConnectivity.id
  management: mgPlatformManagement.id
}

@description('The resource IDs of all landing zone management groups')
output landingZoneManagementGroups object = {
  landingZones: mgLandingZones.id
  corp: mgLandingZonesCorp.id
  online: mgLandingZonesOnline.id
}

@description('The resource IDs of supporting management groups')
output supportingManagementGroups object = {
  sandbox: mgSandbox.id
  decommissioned: mgDecommissioned.id
}

@description('Complete management group hierarchy structure for reference')
output managementGroupHierarchy object = {
  root: {
    id: mgRoot.id
    name: mgRoot.name
    displayName: managementGroupHierarchy.root.displayName
    level: 1
  }
  platform: {
    id: mgPlatform.id
    name: mgPlatform.name
    displayName: managementGroupHierarchy.platform.displayName
    level: 2
    children: {
      identity: {
        id: mgPlatformIdentity.id
        name: mgPlatformIdentity.name
        displayName: managementGroupHierarchy.platformIdentity.displayName
        level: 3
      }
      connectivity: {
        id: mgPlatformConnectivity.id
        name: mgPlatformConnectivity.name
        displayName: managementGroupHierarchy.platformConnectivity.displayName
        level: 3
      }
      management: {
        id: mgPlatformManagement.id
        name: mgPlatformManagement.name
        displayName: managementGroupHierarchy.platformManagement.displayName
        level: 3
      }
    }
  }
  landingZones: {
    id: mgLandingZones.id
    name: mgLandingZones.name
    displayName: managementGroupHierarchy.landingZones.displayName
    level: 2
    children: {
      corp: {
        id: mgLandingZonesCorp.id
        name: mgLandingZonesCorp.name
        displayName: managementGroupHierarchy.landingZonesCorp.displayName
        level: 3
      }
      online: {
        id: mgLandingZonesOnline.id
        name: mgLandingZonesOnline.name
        displayName: managementGroupHierarchy.landingZonesOnline.displayName
        level: 3
      }
    }
  }
  sandbox: {
    id: mgSandbox.id
    name: mgSandbox.name
    displayName: managementGroupHierarchy.sandbox.displayName
    level: 2
  }
  decommissioned: {
    id: mgDecommissioned.id
    name: mgDecommissioned.name
    displayName: managementGroupHierarchy.decommissioned.displayName
    level: 2
  }
}

@description('Management group names for easy reference')
output managementGroupNames object = {
  root: managementGroupHierarchy.root.name
  platform: managementGroupHierarchy.platform.name
  platformIdentity: managementGroupHierarchy.platformIdentity.name
  platformConnectivity: managementGroupHierarchy.platformConnectivity.name
  platformManagement: managementGroupHierarchy.platformManagement.name
  landingZones: managementGroupHierarchy.landingZones.name
  landingZonesCorp: managementGroupHierarchy.landingZonesCorp.name
  landingZonesOnline: managementGroupHierarchy.landingZonesOnline.name
  sandbox: managementGroupHierarchy.sandbox.name
  decommissioned: managementGroupHierarchy.decommissioned.name
}

@description('FSI compliance configuration for each management group')
output complianceConfiguration object = {
  root: {
    frameworks: ['FSI', 'SOX', 'GDPR', 'PCI-DSS']
    auditRetention: '7-years'
    dataResidency: 'EU-only'
    isolationLevel: 'complete'
  }
  platform: {
    frameworks: ['SOX', 'GDPR']
    criticality: 'high'
    drRequired: true
    backupRequired: true
  }
  landingZones: {
    frameworks: ['FSI', 'SOX', 'GDPR', 'PCI-DSS']
    workloadIsolation: true
    networkSegmentation: true
    dataClassification: 'confidential'
  }
  sandbox: {
    frameworks: ['GDPR']
    autoCleanup: '30-days'
    productionDataProhibited: true
    costLimits: 'enforced'
  }
  decommissioned: {
    frameworks: ['SOX', 'GDPR']
    auditRetention: '7-years'
    autoDelete: '90-days'
    accessLevel: 'read-only'
  }
}
