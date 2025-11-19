/*
==============================================================================
AZURE CLOUD FOUNDATION - MAIN ENTRY POINT
==============================================================================

Enterprise Scale Landing Zone Foundation for Toyota Louwmans Financial Services

This main template orchestrates the deployment of the complete Azure Cloud Foundation
including management groups, subscriptions, governance, networking, and monitoring.

Author: Cloud Foundation Team
Version: 1.0.0
Last Updated: November 19, 2025
Repository: https://github.com/patriek-van-dorp/cloud-quick-start-infra

Constitutional Compliance:
- Task: T003 (GH Issue #4)
- Branch: 001-azure-cloud-foundation-task03
- Constitutional Requirements: GitHub Flow Process v1.2.0
*/

targetScope = 'tenant'

// =============================================================================
// METADATA
// =============================================================================

metadata name = 'Azure Cloud Foundation for Toyota Louwmans Financial Services'
metadata description = 'Enterprise Scale Landing Zone Foundation with FSI compliance'
metadata version = '1.0.0'
metadata author = 'Cloud Foundation Team <cloudfoundation@toyotalouwmansfs.nl>'
metadata repository = 'https://github.com/patriek-van-dorp/cloud-quick-start-infra'

// =============================================================================
// PARAMETERS
// =============================================================================

@description('Environment name (dev, test, staging, prod)')
@allowed(['dev', 'test', 'staging', 'prod'])
param environment string = 'dev'

@description('Primary Azure region for deployment')
@allowed(['westeurope', 'northeurope'])
param primaryRegion string = 'westeurope'

@description('Secondary Azure region for disaster recovery')
@allowed(['westeurope', 'northeurope'])
param secondaryRegion string = 'northeurope'

@description('Organization name for resource naming')
param organizationName string = 'ToyotaLouwmansFS'

@description('Root management group display name')
param rootManagementGroupName string = 'Toyota Louwmans Financial Services'

@description('Enable deployment of management groups')
param deployManagementGroups bool = true

@description('Enable deployment of subscriptions')
param deploySubscriptions bool = false

@description('Enable deployment of governance policies')
param deployGovernance bool = false

@description('Enable deployment of networking components')
param deployNetworking bool = false

@description('Enable deployment of monitoring and security')
param deployMonitoring bool = false

@description('Tags to be applied to all resources')
param commonTags object = {
  Organization: 'Toyota Louwmans Financial Services'
  Project: 'Azure Cloud Foundation'
  Environment: environment
  CostCenter: 'IT-Infrastructure'
  Owner: 'Cloud Foundation Team'
  ComplianceFramework: 'FSI'
  DataClassification: 'Internal'
  BusinessCriticality: 'High'
  DeploymentMethod: 'Bicep-IaC'
  LastUpdated: utcNow('yyyy-MM-dd')
}

@description('Configuration for FSI compliance requirements')
param complianceConfig object = {
  enableSOXCompliance: true
  enablePCIDSSCompliance: true
  enableGDPRCompliance: true
  auditRetentionYears: 7
  dataResidencyRegions: ['westeurope', 'northeurope']
  isolationLevel: 'COMPLETE'
}

@description('Configuration for budget and cost management')
param budgetConfig object = {
  enableBudgetAlerts: true
  monthlyBudgetThreshold: 10000
  budgetAlertContacts: [
    'finance@toyotalouwmansfs.nl'
    'cloudfoundation@toyotalouwmansfs.nl'
  ]
}

// =============================================================================
// VARIABLES
// =============================================================================

var deploymentName = 'azure-foundation-${environment}-${utcNow('yyyyMMdd-HHmmss')}'
var namingPrefix = '${organizationName}-${environment}'

// Management Group Hierarchy (8 levels as per data model)
var managementGroupHierarchy = {
  root: {
    id: 'mg-${namingPrefix}-root'
    displayName: rootManagementGroupName
    level: 1
  }
  platform: {
    id: 'mg-${namingPrefix}-platform'
    displayName: '${rootManagementGroupName} - Platform'
    parentId: 'mg-${namingPrefix}-root'
    level: 2
  }
  landingZones: {
    id: 'mg-${namingPrefix}-landingzones'
    displayName: '${rootManagementGroupName} - Landing Zones'
    parentId: 'mg-${namingPrefix}-root'
    level: 2
  }
  connectivity: {
    id: 'mg-${namingPrefix}-connectivity'
    displayName: '${rootManagementGroupName} - Connectivity'
    parentId: 'mg-${namingPrefix}-platform'
    level: 3
  }
  identity: {
    id: 'mg-${namingPrefix}-identity'
    displayName: '${rootManagementGroupName} - Identity'
    parentId: 'mg-${namingPrefix}-platform'
    level: 3
  }
  management: {
    id: 'mg-${namingPrefix}-management'
    displayName: '${rootManagementGroupName} - Management'
    parentId: 'mg-${namingPrefix}-platform'
    level: 3
  }
  corp: {
    id: 'mg-${namingPrefix}-corp'
    displayName: '${rootManagementGroupName} - Corporate'
    parentId: 'mg-${namingPrefix}-landingzones'
    level: 3
  }
  online: {
    id: 'mg-${namingPrefix}-online'
    displayName: '${rootManagementGroupName} - Online'
    parentId: 'mg-${namingPrefix}-landingzones'
    level: 3
  }
}

// Subscription Configuration
var subscriptionConfig = {
  connectivity: {
    displayName: '${organizationName} - Connectivity (${environment})'
    managementGroupId: managementGroupHierarchy.connectivity.id
    workloadType: 'PLATFORM'
    subscriptionType: environment == 'prod' ? 'PRODUCTION' : 'NON_PRODUCTION'
  }
  identity: {
    displayName: '${organizationName} - Identity (${environment})'
    managementGroupId: managementGroupHierarchy.identity.id
    workloadType: 'PLATFORM'
    subscriptionType: environment == 'prod' ? 'PRODUCTION' : 'NON_PRODUCTION'
  }
  management: {
    displayName: '${organizationName} - Management (${environment})'
    managementGroupId: managementGroupHierarchy.management.id
    workloadType: 'PLATFORM'
    subscriptionType: environment == 'prod' ? 'PRODUCTION' : 'NON_PRODUCTION'
  }
}

// =============================================================================
// MODULES
// =============================================================================

// Management Groups Deployment
module managementGroups 'modules/management-groups/main.bicep' = if (deployManagementGroups) {
  name: '${deploymentName}-management-groups'
  scope: tenant()
  params: {
    managementGroupHierarchy: managementGroupHierarchy
    commonTags: commonTags
    environment: environment
  }
}

// Subscriptions Deployment (placeholder - requires existing subscriptions)
module subscriptions 'modules/subscriptions/main.bicep' = if (deploySubscriptions) {
  name: '${deploymentName}-subscriptions'
  scope: tenant()
  dependsOn: [
    managementGroups
  ]
  params: {
    subscriptionConfig: subscriptionConfig
    managementGroupHierarchy: managementGroupHierarchy
    commonTags: commonTags
    environment: environment
  }
}

// Governance and Policies Deployment
module governance 'modules/governance/main.bicep' = if (deployGovernance) {
  name: '${deploymentName}-governance'
  scope: managementGroup(managementGroupHierarchy.root.id)
  dependsOn: [
    managementGroups
  ]
  params: {
    managementGroupHierarchy: managementGroupHierarchy
    complianceConfig: complianceConfig
    commonTags: commonTags
    environment: environment
  }
}

// Cost Management Deployment
module costManagement 'modules/cost-management/main.bicep' = if (deployGovernance) {
  name: '${deploymentName}-cost-management'
  scope: managementGroup(managementGroupHierarchy.root.id)
  dependsOn: [
    managementGroups
  ]
  params: {
    managementGroupHierarchy: managementGroupHierarchy
    budgetConfig: budgetConfig
    commonTags: commonTags
    environment: environment
  }
}

// Networking Deployment (placeholder for future implementation)
module networking 'modules/networking/main.bicep' = if (deployNetworking) {
  name: '${deploymentName}-networking'
  scope: managementGroup(managementGroupHierarchy.connectivity.id)
  dependsOn: [
    managementGroups
    subscriptions
  ]
  params: {
    primaryRegion: primaryRegion
    secondaryRegion: secondaryRegion
    commonTags: commonTags
    environment: environment
    complianceConfig: complianceConfig
  }
}

// Monitoring and Security Deployment (placeholder for future implementation)
module monitoring 'modules/monitoring/main.bicep' = if (deployMonitoring) {
  name: '${deploymentName}-monitoring'
  scope: managementGroup(managementGroupHierarchy.management.id)
  dependsOn: [
    managementGroups
    subscriptions
  ]
  params: {
    primaryRegion: primaryRegion
    secondaryRegion: secondaryRegion
    complianceConfig: complianceConfig
    commonTags: commonTags
    environment: environment
  }
}

// =============================================================================
// OUTPUTS
// =============================================================================

@description('Deployment timestamp')
output deploymentTimestamp string = utcNow()

@description('Environment deployed')
output environment string = environment

@description('Primary region')
output primaryRegion string = primaryRegion

@description('Secondary region')
output secondaryRegion string = secondaryRegion

@description('Root management group information')
output rootManagementGroup object = {
  id: managementGroupHierarchy.root.id
  displayName: managementGroupHierarchy.root.displayName
  level: managementGroupHierarchy.root.level
}

@description('Management group hierarchy deployed')
output managementGroupHierarchy object = deployManagementGroups ? managementGroupHierarchy : {}

@description('Compliance configuration applied')
output complianceConfiguration object = complianceConfig

@description('Common tags applied to resources')
output appliedTags object = commonTags

@description('Deployment status summary')
output deploymentStatus object = {
  managementGroupsDeployed: deployManagementGroups
  subscriptionsDeployed: deploySubscriptions
  governanceDeployed: deployGovernance
  networkingDeployed: deployNetworking
  monitoringDeployed: deployMonitoring
  timestamp: utcNow()
}

/*
==============================================================================
DEPLOYMENT INSTRUCTIONS
==============================================================================

1. Prerequisites:
   - Azure CLI or PowerShell with Bicep installed
   - Tenant-level permissions (Global Administrator or equivalent)
   - Access to target subscription(s)

2. Basic Deployment (Management Groups Only):
   az deployment tenant create \
     --location westeurope \
     --template-file main.bicep \
     --parameters environment=dev deployManagementGroups=true

3. Full Development Environment:
   az deployment tenant create \
     --location westeurope \
     --template-file main.bicep \
     --parameters @environments/dev-parameters.json

4. Production Environment:
   az deployment tenant create \
     --location westeurope \
     --template-file main.bicep \
     --parameters @environments/prod-parameters.json

5. Incremental Deployment:
   Enable specific components by setting deployment flags:
   - deployManagementGroups: true/false
   - deploySubscriptions: true/false  
   - deployGovernance: true/false
   - deployNetworking: true/false
   - deployMonitoring: true/false

==============================================================================
VALIDATION AND TESTING
==============================================================================

1. Validate template:
   az deployment tenant validate \
     --location westeurope \
     --template-file main.bicep \
     --parameters @environments/dev-parameters.json

2. What-if analysis:
   az deployment tenant what-if \
     --location westeurope \
     --template-file main.bicep \
     --parameters @environments/dev-parameters.json

3. Test deployment in dev environment before production

==============================================================================
*/