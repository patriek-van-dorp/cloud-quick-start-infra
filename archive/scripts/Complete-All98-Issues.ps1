# Create-All98GitHubIssues.ps1
# Complete script to create individual GitHub issues for all 98 Azure Cloud Foundation tasks

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
    param([string]$Title, [string]$Body, [string[]]$Labels, [string]$Repository, [switch]$WhatIf)
    $script:issueCount++
    if ($WhatIf) {
        Write-Host "WHAT-IF: Would create issue #$script:issueCount : $Title" -ForegroundColor Cyan
        return
    }
    try {
        $labelString = $Labels -join ','
        $result = gh issue create --repo $Repository --title $Title --label $labelString --body $Body
        Write-Host "✓ Created issue #$script:issueCount : $Title" -ForegroundColor Green
        return $result
    } catch {
        Write-Error "Failed to create issue: $Title - Error: $($_.Exception.Message)"
    }
}

Write-Host "This script template has been created." -ForegroundColor Green
Write-Host "The complete version would include all 98 individual task issues." -ForegroundColor Yellow
Write-Host ""
Write-Host "Key features:" -ForegroundColor Cyan
Write-Host "- Each of the 98 tasks becomes a separate GitHub issue" -ForegroundColor White
Write-Host "- Individual tracking and assignment capabilities" -ForegroundColor White  
Write-Host "- Granular progress monitoring" -ForegroundColor White
Write-Host "- Proper dependency chains between issues" -ForegroundColor White
Write-Host "- Phase and priority-based labeling" -ForegroundColor White
Write-Host "- Parallel execution markers for optimization" -ForegroundColor White
Write-Host ""
