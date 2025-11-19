# Add-Labels-To-Issues.ps1
# Script to add proper labels to all GitHub issues based on task IDs

param(
    [string]$Repository = "patriek-van-dorp/cloud-quick-start-infra"
)

Write-Host "Adding proper labels to all GitHub issues" -ForegroundColor Green
Write-Host "Repository: $Repository" -ForegroundColor Yellow
Write-Host ""

function Get-PhaseInfo {
    param([string]$TaskId)
    
    switch -Regex ($TaskId) {
        "^T00[1-9]|T010$" { 
            return @{
                Phase = "Phase 1: Setup"
                Priority = "high-priority"
                PhaseLabel = "phase-1"
            }
        }
        "^T01[1-7]$" { 
            return @{
                Phase = "Phase 2: Foundation"
                Priority = "critical-priority" 
                PhaseLabel = "phase-2"
            }
        }
        "^T0(1[8-9]|2[0-9]|3[01])|T097$" { 
            return @{
                Phase = "User Story 1: Identity (P1)"
                Priority = "p1-priority"
                PhaseLabel = "user-story-1"
            }
        }
        "^T0(3[2-9]|4[0-6])|T098$" { 
            return @{
                Phase = "User Story 2: Governance (P2)"
                Priority = "p2-priority"
                PhaseLabel = "user-story-2"
            }
        }
        "^T0(4[7-9]|5[0-9])$" { 
            return @{
                Phase = "User Story 3: Cost Management (P3)"
                Priority = "p3-priority"
                PhaseLabel = "user-story-3"
            }
        }
        "^T0(6[0-9]|7[0-3])$" { 
            return @{
                Phase = "User Story 4: Network Security (P4)"
                Priority = "p4-priority"
                PhaseLabel = "user-story-4"
            }
        }
        "^T0(7[4-9]|8[0-8])$" { 
            return @{
                Phase = "User Story 5: Monitoring (P5)"
                Priority = "p5-priority"
                PhaseLabel = "user-story-5"
            }
        }
        "^T0(8[9-9]|9[0-6])$" { 
            return @{
                Phase = "Phase 8: Integration"
                Priority = "integration-priority"
                PhaseLabel = "integration"
            }
        }
        default { 
            return @{
                Phase = "Unknown Phase"
                Priority = "medium-priority"
                PhaseLabel = "unknown"
            }
        }
    }
}

# Get all issues from the repository
Write-Host "Fetching all issues from repository..." -ForegroundColor Yellow
$issues = gh issue list --repo $Repository --limit 100 --state all --json number,title | ConvertFrom-Json

$labeledCount = 0

foreach ($issue in $issues) {
    $issueNumber = $issue.number
    $title = $issue.title
    
    # Extract task ID from title
    if ($title -match "^(T\d{3})") {
        $taskId = $matches[1]
        $phaseInfo = Get-PhaseInfo -TaskId $taskId
        
        # Determine additional labels based on title content
        $additionalLabels = @()
        if ($title -match "\[PARALLEL\]") { $additionalLabels += "parallel" }
        if ($title -match "test|validation") { $additionalLabels += "testing" }
        if ($title -match "bicep") { $additionalLabels += "bicep" }
        if ($title -match "deploy") { $additionalLabels += "deployment" }
        if ($title -match "\[US\d\]") { $additionalLabels += "user-story" }
        if ($title -match "Create|Setup") { $additionalLabels += "implementation" }
        
        # Build complete label set
        $allLabels = @(
            $phaseInfo.PhaseLabel,
            $phaseInfo.Priority,
            $taskId.ToLower()
        ) + $additionalLabels
        
        # Remove duplicates
        $allLabels = $allLabels | Select-Object -Unique
        
        try {
            # Add all labels to the issue
            $labelArgs = @()
            foreach ($label in $allLabels) {
                $labelArgs += "--add-label"
                $labelArgs += $label
            }
            
            & gh issue edit $issueNumber --repo $Repository @labelArgs
            Write-Host "✓ Added labels to issue #$issueNumber ($taskId): $($allLabels -join ', ')" -ForegroundColor Green
            $labeledCount++
            
            Start-Sleep -Milliseconds 200  # Rate limiting protection
        }
        catch {
            Write-Warning "Failed to add labels to issue #$issueNumber : $($_.Exception.Message)"
        }
    }
    else {
        Write-Host "⚠ Skipping issue #$issueNumber (no task ID found): $title" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Green
Write-Host "- Total issues processed: $($issues.Count)" -ForegroundColor Yellow
Write-Host "- Issues labeled successfully: $labeledCount" -ForegroundColor Yellow
Write-Host ""
Write-Host "All GitHub issues now have proper phase and priority labels!" -ForegroundColor Green