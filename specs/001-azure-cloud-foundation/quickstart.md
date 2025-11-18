# Quick Start Guide: Azure Cloud Foundation for Toyota Louwmans Financial Services

**Version**: 1.0.0  
**Date**: November 18, 2025  
**Audience**: IT Administrators, DevOps Engineers, Compliance Officers

## Overview

This quick start guide provides step-by-step instructions to deploy and configure the Azure Cloud Foundation for Toyota Louwmans Financial Services. The foundation implements Enterprise Scale Landing Zone patterns with FSI compliance, complete isolation from parent company, and comprehensive governance controls.

## Prerequisites

### Required Access
- **Azure AD Global Administrator** role in Toyota Louwmans Financial Services tenant
- **Owner** role on target Azure subscription(s)
- **Billing Administrator** access for cost management setup

### Required Tools
- **Azure CLI** (version 2.50.0 or later)
- **Azure PowerShell** (version 9.0.0 or later)  
- **Bicep CLI** (version 0.20.0 or later)
- **Git** for source control
- **Visual Studio Code** (recommended) with Azure extensions

### Verify Prerequisites
```powershell
# Verify Azure CLI installation and login
az --version
az login --tenant "toyotalouwmansfs.onmicrosoft.com"

# Verify Azure PowerShell
Get-Module -Name Az -ListAvailable
Connect-AzAccount -Tenant "toyotalouwmansfs.onmicrosoft.com"

# Verify Bicep CLI
bicep --version

# Set Azure CLI defaults
az config set defaults.location=westeurope
az config set defaults.group=""
```

## Phase 1: Foundation Setup (Week 1)

### Step 1: Clone and Setup Repository
```powershell
# Clone the repository
git clone https://github.com/patriek-van-dorp/cloud-quick-start-infra.git
cd cloud-quick-start-infra

# Switch to feature branch
git checkout 001-azure-cloud-foundation

# Review the structure
tree /f
```

### Step 2: Configure Management Group Hierarchy
```powershell
# Set variables for deployment
$tenantId = "your-tenant-id-here"
$managementGroupPrefix = "tlfs"  # Toyota Louwmans Financial Services
$primaryRegion = "westeurope"
$secondaryRegion = "northeurope"

# Deploy management group hierarchy
cd management-groups
az deployment tenant create \
  --location $primaryRegion \
  --template-file main.bicep \
  --parameters tenantId=$tenantId managementGroupPrefix=$managementGroupPrefix

# Verify management group creation
az account management-group list --query '[].{Name:name, DisplayName:displayName}'
```

### Step 3: Create Core Subscriptions
```powershell
# Create subscriptions using Azure CLI or Portal
# Note: Subscription creation requires billing admin access

# Production subscriptions
$subscriptions = @{
    "Identity-Prod" = "sub-tlfs-identity-prod"
    "Connectivity-Prod" = "sub-tlfs-connectivity-prod"  
    "Management-Prod" = "sub-tlfs-management-prod"
    "Corp-Prod" = "sub-tlfs-corp-prod"
}

# For each subscription, place in correct management group
foreach ($sub in $subscriptions.GetEnumerator()) {
    az account management-group subscription add \
      --name "$managementGroupPrefix-platform" \
      --subscription $sub.Value
}
```

### Step 4: Deploy Core Policies
```powershell
# Deploy foundational policies
cd ../management-groups/policies

# Deploy identity policies
az deployment mg create \
  --management-group-id "$managementGroupPrefix-root" \
  --location $primaryRegion \
  --template-file identity-policies.bicep

# Deploy security policies  
az deployment mg create \
  --management-group-id "$managementGroupPrefix-root" \
  --location $primaryRegion \
  --template-file security-policies.bicep

# Deploy compliance policies
az deployment mg create \
  --management-group-id "$managementGroupPrefix-root" \
  --location $primaryRegion \
  --template-file compliance-policies.bicep

# Verify policy assignments
az policy assignment list --query '[].{Name:name, PolicyDefinitionId:policyDefinitionId}'
```

## Phase 2: Identity and Security (Week 2)

### Step 5: Configure Azure AD Integration
```powershell
# Connect to Azure AD
Connect-AzureAD -TenantId $tenantId

# Create custom roles for FSI compliance
cd ../subscriptions/identity

# Deploy identity infrastructure
az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-identity-prod" \
  --template-file main.bicep \
  --parameters primaryRegion=$primaryRegion

# Configure conditional access policies
az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-identity-prod" \
  --template-file conditional-access.bicep
```

### Step 6: Setup Privileged Access Management
```powershell
# Deploy privileged access infrastructure
az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-identity-prod" \
  --template-file privileged-access.bicep

# Configure emergency access accounts
# Note: Emergency access accounts require manual configuration for security
```

### Step 7: Deploy RBAC Assignments
```powershell
# Deploy custom RBAC roles
cd ../management-groups/rbac

az deployment mg create \
  --management-group-id "$managementGroupPrefix-root" \
  --location $primaryRegion \
  --template-file fsi-roles.bicep

# Deploy emergency access procedures
az deployment mg create \
  --management-group-id "$managementGroupPrefix-root" \
  --location $primaryRegion \
  --template-file emergency-access.bicep
```

## Phase 3: Networking and Connectivity (Week 3)

### Step 8: Deploy Hub Networking
```powershell
# Deploy hub virtual network
cd ../../subscriptions/connectivity

az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-connectivity-prod" \
  --template-file main.bicep \
  --parameters primaryRegion=$primaryRegion secondaryRegion=$secondaryRegion

# Deploy network security groups
az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-connectivity-prod" \
  --template-file network-security-groups.bicep
```

### Step 9: Configure Azure Firewall
```powershell
# Deploy Azure Firewall with threat intelligence
cd ../../shared-services/networking

az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-connectivity-prod" \
  --template-file firewall.bicep \
  --parameters enableThreatIntelligence=true

# Configure firewall rules for FSI compliance
# Rules automatically configured via policy
```

### Step 10: Setup DNS and Network Monitoring
```powershell
# Deploy private DNS zones
az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-connectivity-prod" \
  --template-file dns-zones.bicep

# Verify network connectivity
az network vnet list --query '[].{Name:name, Location:location, AddressSpace:addressSpace}'
```

## Phase 4: Monitoring and Security (Week 4)

### Step 11: Deploy Log Analytics Workspace
```powershell
# Deploy central logging infrastructure
cd ../../subscriptions/management

az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-management-prod" \
  --template-file main.bicep \
  --parameters retentionDays=2555  # 7 years for FSI compliance

# Deploy Log Analytics workspace
az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-management-prod" \
  --template-file log-analytics.bicep
```

### Step 12: Configure Security Monitoring
```powershell
# Deploy Microsoft Defender for Cloud
cd ../../shared-services/security

az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-management-prod" \
  --template-file defender.bicep \
  --parameters enableAdvancedThreatProtection=true

# Deploy Microsoft Sentinel
az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-management-prod" \
  --template-file sentinel.bicep
```

### Step 13: Setup Key Vault for Secrets Management
```powershell
# Deploy Key Vault with FIPS 140-2 Level 2 HSM
az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-management-prod" \
  --template-file key-vault.bicep \
  --parameters enableHsm=true enablePurgeProtection=true
```

## Phase 5: Cost Management and Governance (Week 5)

### Step 14: Configure Cost Management
```powershell
# Deploy cost management infrastructure
cd ../../subscriptions/management

az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-management-prod" \
  --template-file cost-management.bicep \
  --parameters annualBudget=500000  # €500K annual budget

# Setup budget alerts
az consumption budget create \
  --budget-name "tlfs-annual-budget" \
  --amount 500000 \
  --time-grain "Monthly" \
  --start-date "2025-01-01" \
  --end-date "2025-12-31"
```

### Step 15: Deploy Monitoring and Alerting
```powershell
# Deploy comprehensive monitoring
cd ../../shared-services/monitoring

az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-management-prod" \
  --template-file monitoring-alerts.bicep

# Configure Application Insights for application monitoring
az deployment sub create \
  --location $primaryRegion \
  --subscription "sub-tlfs-management-prod" \
  --template-file application-insights.bicep
```

## Phase 6: Testing and Validation (Week 6)

### Step 16: Compliance Validation
```powershell
# Run compliance assessment
az policy state list --management-group "$managementGroupPrefix-root" \
  --query '[?complianceState==`NonCompliant`]' \
  --output table

# Generate compliance report
cd ../../tests/compliance
./Run-ComplianceTests.ps1 -ManagementGroup "$managementGroupPrefix-root"
```

### Step 17: Security Testing
```powershell
# Run security tests
cd ../security
./Run-SecurityTests.ps1 -SubscriptionName "sub-tlfs-management-prod"

# Test emergency access procedures
./Test-EmergencyAccess.ps1 -TestMode $true
```

### Step 18: Performance and Availability Testing
```powershell
# Test disaster recovery procedures
cd ../integration
./Test-DisasterRecovery.ps1 -PrimaryRegion $primaryRegion -SecondaryRegion $secondaryRegion

# Test monitoring and alerting
./Test-MonitoringAlerts.ps1 -LogAnalyticsWorkspace "law-tlfs-prod"
```

## Post-Deployment Configuration

### Configure Backup and Recovery
```powershell
# Enable Azure Backup for critical configurations
az backup vault create \
  --resource-group "rg-tlfs-management-prod" \
  --name "bv-tlfs-management-prod" \
  --location $primaryRegion

# Configure backup policies for virtual machines
az backup policy create \
  --vault-name "bv-tlfs-management-prod" \
  --name "DailyBackupPolicy" \
  --policy backup-policy.json
```

### Setup Audit and Compliance Reporting
```powershell
# Configure audit log streaming to external systems
az monitor diagnostic-settings create \
  --name "audit-streaming" \
  --resource "/subscriptions/sub-tlfs-management-prod" \
  --logs '[{"category": "Administrative", "enabled": true}, {"category": "Security", "enabled": true}]' \
  --workspace "law-tlfs-prod"
```

### Configure Cost Optimization
```powershell
# Enable Azure Advisor recommendations
az advisor configuration update \
  --low-cpu-threshold 20 \
  --exclude-rgs "rg-critical-resources"

# Setup resource tagging automation
# Note: Implemented via Azure Policy - automatic tagging enabled
```

## Verification Checklist

### ✅ Foundation Components
- [ ] Management group hierarchy created and organized
- [ ] Core subscriptions provisioned and assigned
- [ ] Foundational policies deployed and compliant
- [ ] RBAC roles and assignments configured

### ✅ Identity and Security
- [ ] Azure AD integration configured
- [ ] Conditional access policies active
- [ ] Privileged access management enabled
- [ ] Emergency access procedures tested

### ✅ Network and Connectivity
- [ ] Hub-and-spoke networking deployed
- [ ] Azure Firewall configured with threat intelligence
- [ ] Network security groups protecting subnets
- [ ] Private DNS zones configured

### ✅ Monitoring and Security
- [ ] Log Analytics workspace with 7-year retention
- [ ] Microsoft Defender for Cloud enabled
- [ ] Microsoft Sentinel deployed and configured
- [ ] Key Vault with HSM protection active

### ✅ Cost and Governance
- [ ] Budget controls and alerts configured
- [ ] Cost allocation tags applied automatically
- [ ] Monitoring dashboards and alerts active
- [ ] Compliance reporting automated

## Common Issues and Troubleshooting

### Issue: Policy Assignment Failures
```powershell
# Check policy compliance state
az policy state list --management-group "$managementGroupPrefix-root" \
  --filter "complianceState eq 'NonCompliant'" \
  --output table

# Review policy assignment details
az policy assignment list --disable-scope-strict-match \
  --query '[?enforcementMode==`DoNotEnforce`]'
```

### Issue: RBAC Permission Denied
```powershell
# Verify current user permissions
az role assignment list --assignee $(az ad signed-in-user show --query objectId -o tsv) \
  --output table

# Check management group access
az account management-group show --name "$managementGroupPrefix-root" \
  --expand
```

### Issue: Network Connectivity Problems
```powershell
# Test network connectivity
az network vnet list --query '[].{Name:name, Subnets:subnets[].name}'

# Check NSG rules
az network nsg list --query '[].{Name:name, SecurityRules:securityRules[].name}'

# Verify firewall configuration
az network firewall show --name "afw-tlfs-prod" --resource-group "rg-connectivity-prod"
```

### Issue: Cost Budget Alerts Not Working
```powershell
# Check budget configuration
az consumption budget list --output table

# Verify action groups for alerts
az monitor action-group list --query '[].{Name:name, Enabled:enabled}'

# Test alert notifications
az monitor action-group test-notifications create \
  --action-group-name "budget-alerts" \
  --notification-type "email"
```

## Next Steps

### Workload Deployment
1. **Review workload requirements** against foundation capabilities
2. **Create landing zone subscriptions** using subscription vending pattern
3. **Deploy application-specific policies** and RBAC assignments
4. **Configure application monitoring** and cost allocation

### Operational Procedures
1. **Establish monitoring runbooks** for incident response
2. **Create backup and recovery procedures** for critical systems
3. **Implement change management processes** for infrastructure updates
4. **Schedule regular compliance assessments** and security reviews

### Continuous Improvement
1. **Monitor cost optimization opportunities** using Azure Advisor
2. **Review and update compliance policies** based on regulatory changes
3. **Assess new Azure services** for potential integration
4. **Conduct quarterly architecture reviews** with stakeholders

## Support and Documentation

### Internal Resources
- **Cloud Foundation Team**: cloudfoundation@toyotalouwmansfs.nl
- **Security Operations Center**: soc@toyotalouwmansfs.nl  
- **IT Service Desk**: servicedesk@toyotalouwmansfs.nl

### External Resources
- **Azure Enterprise Scale**: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/
- **Azure Verified Modules**: https://azure.github.io/Azure-Verified-Modules/
- **Azure Well-Architected Framework**: https://docs.microsoft.com/en-us/azure/architecture/framework/

### Emergency Contacts
- **Emergency Access**: +31-XX-XXX-XXXX (24/7 availability)
- **Security Incidents**: security-incident@toyotalouwmansfs.nl
- **Microsoft Support**: Use Azure portal support tickets for technical issues

---

**Important**: This guide assumes familiarity with Azure administration and PowerShell scripting. For production deployment, conduct thorough testing in development environment first and ensure all stakeholders review and approve the implementation plan.