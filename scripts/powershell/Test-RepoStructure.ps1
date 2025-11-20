# Repository Structure Validation Script
# Validates the Azure Cloud Foundation repository structure

param(
    [switch]$Json
)

$ErrorActionPreference = "Stop"

# Required paths for Azure Cloud Foundation
$requiredPaths = @(
    # Root files
    "main.bicep",
    "bicepconfig.json",
    "README.md",

    # Core directories
    "management-groups",
    "subscriptions",
    "shared-services",
    "environments",
    "tests",
    "scripts",
    "modules",
    "config",

    # Management Groups structure
    "management-groups/policies",
    "management-groups/rbac",

    # Subscriptions structure
    "subscriptions/connectivity",
    "subscriptions/identity",
    "subscriptions/landing-zones",
    "subscriptions/management",

    # Shared Services structure
    "shared-services/monitoring",
    "shared-services/networking",
    "shared-services/security",

    # Environments
    "environments/dev",
    "environments/prod",
    "environments/staging",
    "environments/test",

    # Tests structure
    "tests/e2e",
    "tests/integration",
    "tests/unit",

    # Scripts structure
    "scripts/powershell",

    # Modules structure
    "modules/cost-management",
    "modules/governance",
    "modules/identity",
    "modules/management-groups",
    "modules/monitoring",
    "modules/networking",
    "modules/security",
    "modules/subscriptions",

    # Config structure
    "config",

    # Specs (design documents)
    "specs/001-azure-cloud-foundation"
)

$validationResults = @()
$allValid = $true

Write-Host "Validating Azure Cloud Foundation repository structure..." -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan

foreach ($path in $requiredPaths) {
    $fullPath = Join-Path $PSScriptRoot "../.." $path
    $exists = Test-Path $fullPath

    if ($exists) {
        Write-Host "✓ $path" -ForegroundColor Green
        $validationResults += @{
            Path = $path
            Status = "PASS"
            Exists = $true
        }
    } else {
        Write-Host "✗ $path" -ForegroundColor Red
        $validationResults += @{
            Path = $path
            Status = "FAIL"
            Exists = $false
        }
        $allValid = $false
    }
}

Write-Host ("=" * 60) -ForegroundColor Cyan

if ($allValid) {
    Write-Host "Repository structure validation: PASS" -ForegroundColor Green
    Write-Host "All required paths exist." -ForegroundColor Green

    if ($Json) {
        $output = @{
            Status = "PASS"
            Message = "All required paths exist"
            Results = $validationResults
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }
        $output | ConvertTo-Json -Depth 3
    }

    exit 0
} else {
    Write-Host "Repository structure validation: FAIL" -ForegroundColor Red
    Write-Host "Some required paths are missing. Please check the repository structure." -ForegroundColor Red

    if ($Json) {
        $output = @{
            Status = "FAIL"
            Message = "Some required paths are missing"
            Results = $validationResults
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }
        $output | ConvertTo-Json -Depth 3
    }

    exit 1
}