# Add-Phase-Priority-Labels.ps1
# Script to create minimal phase and priority labels, then apply them to existing GitHub issues

param(
    [string]$Repository = "patriek-van-dorp/cloud-quick-start-infra",
    [switch]$WhatIf = $false
)

Write-Host "Creating Phase and Priority Labels for GitHub Issues" -ForegroundColor Green
Write-Host "Repository: $Repository" -ForegroundColor Yellow
Write-Host "What-If Mode: $WhatIf" -ForegroundColor Yellow
Write-Host ""

function Get-PhaseInfo {
    param([string]$TaskId)
    
    switch -Regex ($TaskId) {
        "^T00[1-9]|T010$" { 
            return @{
                PhaseLabel = "phase-1"
                PriorityLabel = "high-priority"
            }
        }
        "^T01[1-7]$" { 
            return @{
                PhaseLabel = "phase-2"
                PriorityLabel = "critical-priority"
            }
        }
        "^T0(1[8-9]|2[0-9]|3[01])|T097$" { 
            return @{
                PhaseLabel = "user-story-1"
                PriorityLabel = "p1-priority"
            }
        }
        "^T0(3[2-9]|4[0-6])|T098$" { 
            return @{
                PhaseLabel = "user-story-2"
                PriorityLabel = "p2-priority"
            }
        }
        "^T0(4[7-9]|5[0-9])$" { 
            return @{
                PhaseLabel = "user-story-3"
                PriorityLabel = "p3-priority"
            }
        }
        "^T0(6[0-9]|7[0-3])$" { 
            return @{
                PhaseLabel = "user-story-4"
                PriorityLabel = "p4-priority"
            }
        }
        "^T0(7[4-9]|8[0-8])$" { 
            return @{
                PhaseLabel = "user-story-5"
                PriorityLabel = "p5-priority"
            }
        }
        "^T0(8[9-9]|9[0-6])$" { 
            return @{
                PhaseLabel = "integration"
                PriorityLabel = "high-priority"
            }
        }
        default { 
            return @{
                PhaseLabel = "unknown"
                PriorityLabel = "medium-priority"
            }
        }
    }
}

# Define the minimal label set
$labels = @(
    @{name="phase-1"; color="0e8a16"; description="Phase 1: Setup - Project Foundation"},
    @{name="phase-2"; color="d93f0b"; description="Phase 2: Foundation Infrastructure (Critical)"},
    @{name="user-story-1"; color="5319e7"; description="User Story 1: Identity and Access Foundation (P1)"},
    @{name="user-story-2"; color="0052cc"; description="User Story 2: Governance and Compliance Framework (P2)"},
    @{name="user-story-3"; color="006b75"; description="User Story 3: Cost Management and Resource Governance (P3)"},
    @{name="user-story-4"; color="7057ff"; description="User Story 4: Network Security and Connectivity (P4)"},
    @{name="user-story-5"; color="a2eeef"; description="User Story 5: Monitoring and Operational Visibility (P5)"},
    @{name="integration"; color="e99695"; description="Phase 8: Integration and Polish"},
    @{name="critical-priority"; color="b60205"; description="Critical Priority - Blocking"},
    @{name="high-priority"; color="d93f0b"; description="High Priority"},
    @{name="p1-priority"; color="0052cc"; description="P1 Priority (Highest User Story)"},
    @{name="p2-priority"; color="0e8a16"; description="P2 Priority"},
    @{name="p3-priority"; color="fbca04"; description="P3 Priority"},
    @{name="p4-priority"; color="f9d0c4"; description="P4 Priority"},
    @{name="p5-priority"; color="c5def5"; description="P5 Priority (Lowest User Story)"},
    @{name="medium-priority"; color="7f8c8d"; description="Medium Priority"}
)

Write-Host "Step 1: Creating labels..." -ForegroundColor Yellow

foreach ($label in $labels) {
    if ($WhatIf) {
        Write-Host "WHAT-IF: Would create label '$($label.name)' with color $($label.color)" -ForegroundColor Cyan
    } else {
        try {
            gh label create $label.name --color $label.color --description $label.description --repo $Repository 2>$null
            Write-Host "✓ Created label: $($label.name)" -ForegroundColor Green
        }
        catch {
            Write-Host "• Label already exists: $($label.name)" -ForegroundColor Gray
        }
    }
}

Write-Host ""
Write-Host "Step 2: Getting existing issues..." -ForegroundColor Yellow

# Get all issues and extract task IDs from titles
if ($WhatIf) {
    Write-Host "WHAT-IF: Would fetch all GitHub issues and apply labels" -ForegroundColor Cyan
} else {
    $issues = gh issue list --repo $Repository --limit 200 --json number,title --jq '.[]'
    $issuesData = $issues | ConvertFrom-Json
    
    Write-Host "Found $($issuesData.Count) issues to process" -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($issue in $issuesData) {
        # Extract task ID from title (format: "T001 - Description...")
        if ($issue.title -match "^(T\d{3})") {
            $taskId = $matches[1]
            $phaseInfo = Get-PhaseInfo -TaskId $taskId
            
            try {
                gh issue edit $issue.number --add-label $phaseInfo.PhaseLabel --add-label $phaseInfo.PriorityLabel --repo $Repository
                Write-Host "✓ Issue #$($issue.number) ($taskId): Added $($phaseInfo.PhaseLabel), $($phaseInfo.PriorityLabel)" -ForegroundColor Green
                Start-Sleep -Milliseconds 200  # Rate limiting
            }
            catch {
                Write-Warning "Failed to add labels to issue #$($issue.number): $($_.Exception.Message)"
            }
        }
        else {
            Write-Host "• Skipping issue #$($issue.number): No task ID found in title" -ForegroundColor Gray
        }
    }
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Green
Write-Host "- Phase Labels: phase-1, phase-2, user-story-1 through user-story-5, integration" -ForegroundColor Yellow
Write-Host "- Priority Labels: critical-priority, high-priority, p1-priority through p5-priority, medium-priority" -ForegroundColor Yellow
Write-Host "- All existing issues have been labeled with appropriate phase and priority" -ForegroundColor Yellow
Write-Host ""

if ($WhatIf) {
    Write-Host "WhatIf Mode Complete - No actual labels created or applied" -ForegroundColor Cyan
    Write-Host "Run without -WhatIf to create labels and apply them to issues" -ForegroundColor Cyan
} else {
    Write-Host "Phase and priority labeling complete!" -ForegroundColor Green
    Write-Host "Check your repository: https://github.com/$Repository/issues" -ForegroundColor Blue
}