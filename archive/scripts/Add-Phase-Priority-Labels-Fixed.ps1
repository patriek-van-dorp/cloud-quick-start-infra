# Add-Phase-Priority-Labels-Fixed.ps1
# Script to create 8 phase labels and P1-P5 priority labels, then apply them to existing GitHub issues

param(
    [string]$Repository = "patriek-van-dorp/cloud-quick-start-infra",
    [switch]$WhatIf = $false
)

Write-Host "Creating Phase and Priority Labels for GitHub Issues" -ForegroundColor Green
Write-Host "Repository: $Repository" -ForegroundColor Yellow
Write-Host "What-If Mode: $WhatIf" -ForegroundColor Yellow
Write-Host ""

# Define the 8 phase labels - one for each phase in tasks.md
$phaseLabels = @(
    @{name="phase-1-setup"; color="0e8a16"; description="Phase 1: Setup (Project Foundation)"}
    @{name="phase-2-foundation"; color="d93f0b"; description="Phase 2: Foundational Infrastructure"}
    @{name="phase-3-identity"; color="5319e7"; description="Phase 3: User Story 1 - Identity and Access Foundation"}
    @{name="phase-4-governance"; color="0052cc"; description="Phase 4: User Story 2 - Governance and Compliance Framework"}
    @{name="phase-5-cost-mgmt"; color="006b75"; description="Phase 5: User Story 3 - Cost Management and Resource Governance"}
    @{name="phase-6-networking"; color="7057ff"; description="Phase 6: User Story 4 - Network Security and Connectivity"}
    @{name="phase-7-monitoring"; color="a2eeef"; description="Phase 7: User Story 5 - Monitoring and Operational Visibility"}
    @{name="phase-8-integration"; color="e99695"; description="Phase 8: Integration and Polish"}
)

# Define the 5 priority labels - P1 through P5 only (no ambiguous labels)
$priorityLabels = @(
    @{name="priority-p1"; color="b60205"; description="Priority P1 - Identity and Access Foundation"}
    @{name="priority-p2"; color="d93f0b"; description="Priority P2 - Governance and Compliance Framework"}
    @{name="priority-p3"; color="fbca04"; description="Priority P3 - Cost Management and Resource Governance"}
    @{name="priority-p4"; color="f9d0c4"; description="Priority P4 - Network Security and Connectivity"}
    @{name="priority-p5"; color="c5def5"; description="Priority P5 - Monitoring and Operational Visibility"}
)

function Get-TaskLabels {
    param([string]$TaskId)
    
    switch -Regex ($TaskId) {
        # Phase 1: Setup (T001-T010)
        "^T00[1-9]|T010$" { 
            return @{
                PhaseLabel = "phase-1-setup"
                PriorityLabel = $null # Setup tasks don't have user story priority
            }
        }
        # Phase 2: Foundation (T011-T017)
        "^T01[1-7]$" { 
            return @{
                PhaseLabel = "phase-2-foundation"
                PriorityLabel = $null # Foundation tasks don't have user story priority
            }
        }
        # Phase 3: US1 Identity (T018-T031, T097)
        "^T0(1[8-9]|2[0-9]|3[01])|T097$" { 
            return @{
                PhaseLabel = "phase-3-identity"
                PriorityLabel = "priority-p1"
            }
        }
        # Phase 4: US2 Governance (T032-T046, T098)
        "^T0(3[2-9]|4[0-6])|T098$" { 
            return @{
                PhaseLabel = "phase-4-governance"
                PriorityLabel = "priority-p2"
            }
        }
        # Phase 5: US3 Cost Management (T047-T059)
        "^T0(4[7-9]|5[0-9])$" { 
            return @{
                PhaseLabel = "phase-5-cost-mgmt"
                PriorityLabel = "priority-p3"
            }
        }
        # Phase 6: US4 Networking (T060-T073)
        "^T0(6[0-9]|7[0-3])$" { 
            return @{
                PhaseLabel = "phase-6-networking"
                PriorityLabel = "priority-p4"
            }
        }
        # Phase 7: US5 Monitoring (T074-T088)
        "^T0(7[4-9]|8[0-8])$" { 
            return @{
                PhaseLabel = "phase-7-monitoring"
                PriorityLabel = "priority-p5"
            }
        }
        # Phase 8: Integration (T089-T096)
        "^T0(8[9-9]|9[0-6])$" { 
            return @{
                PhaseLabel = "phase-8-integration"
                PriorityLabel = $null # Integration tasks don't have user story priority
            }
        }
        default { 
            return @{
                PhaseLabel = $null
                PriorityLabel = $null
            }
        }
    }
}

Write-Host "Step 1: Creating all phase labels..." -ForegroundColor Yellow

foreach ($label in $phaseLabels) {
    if ($WhatIf) {
        Write-Host "WHAT-IF: Would create phase label '$($label.name)'" -ForegroundColor Cyan
    } else {
        try {
            gh label create $label.name --description $label.description --color $label.color --repo $Repository
            Write-Host "✓ Created phase label: $($label.name)" -ForegroundColor Green
        } catch {
            Write-Host "⚠ Phase label '$($label.name)' may already exist or creation failed" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "Step 2: Creating all priority labels..." -ForegroundColor Yellow

foreach ($label in $priorityLabels) {
    if ($WhatIf) {
        Write-Host "WHAT-IF: Would create priority label '$($label.name)'" -ForegroundColor Cyan
    } else {
        try {
            gh label create $label.name --description $label.description --color $label.color --repo $Repository
            Write-Host "✓ Created priority label: $($label.name)" -ForegroundColor Green
        } catch {
            Write-Host "⚠ Priority label '$($label.name)' may already exist or creation failed" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "Step 3: Applying labels to existing issues..." -ForegroundColor Yellow

if ($WhatIf) {
    Write-Host "WHAT-IF: Would apply labels to all 98 GitHub issues based on task mapping" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Label Mapping Summary:" -ForegroundColor Magenta
    Write-Host "Phase Labels: $($phaseLabels.name -join ', ')" -ForegroundColor White
    Write-Host "Priority Labels: $($priorityLabels.name -join ', ')" -ForegroundColor White
} else {
    # Get all issues (should be #2-#99 based on our previous creation)
    $issues = gh issue list --repo $Repository --limit 100 --state all --json number,title | ConvertFrom-Json
    
    $successCount = 0
    $errorCount = 0
    
    foreach ($issue in $issues) {
        # Extract task ID from issue title (format should be like "T001: Create repository structure...")
        if ($issue.title -match "^(T\d{3})") {
            $taskId = $matches[1]
            $labels = Get-TaskLabels -TaskId $taskId
            
            $labelsToApply = @()
            if ($labels.PhaseLabel) { $labelsToApply += $labels.PhaseLabel }
            if ($labels.PriorityLabel) { $labelsToApply += $labels.PriorityLabel }
            
            if ($labelsToApply.Count -gt 0) {
                try {
                    $labelString = $labelsToApply -join ','
                    gh issue edit $issue.number --add-label $labelString --repo $Repository
                    Write-Host "✓ Applied labels to issue #$($issue.number) ($taskId): $($labelsToApply -join ', ')" -ForegroundColor Green
                    $successCount++
                } catch {
                    Write-Host "✗ Failed to apply labels to issue #$($issue.number) ($taskId)" -ForegroundColor Red
                    $errorCount++
                }
            } else {
                Write-Host "⚠ No labels mapped for issue #$($issue.number) ($taskId)" -ForegroundColor Yellow
                $errorCount++
            }
        } else {
            Write-Host "⚠ Could not extract task ID from issue #$($issue.number): $($issue.title)" -ForegroundColor Yellow
            $errorCount++
        }
    }
    
    Write-Host ""
    Write-Host "Labeling Summary:" -ForegroundColor Magenta
    Write-Host "✓ Successfully labeled: $successCount issues" -ForegroundColor Green
    Write-Host "✗ Errors/Warnings: $errorCount issues" -ForegroundColor Red
}

Write-Host ""
Write-Host "Phase and Priority Labeling Complete!" -ForegroundColor Green
Write-Host "Phase Labels Created: $($phaseLabels.Count) (phase-1-setup through phase-8-integration)" -ForegroundColor White
Write-Host "Priority Labels Created: $($priorityLabels.Count) (priority-p1 through priority-p5)" -ForegroundColor White
Write-Host ""
Write-Host "Labels can now be used to filter issues by phase and priority for junior engineers" -ForegroundColor Cyan