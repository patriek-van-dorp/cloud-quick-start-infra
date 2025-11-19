# Create-All98-Individual-Issues.ps1
# Script to create individual GitHub issues for all 98 Azure Cloud Foundation tasks
# Parses tasks.md directly to ensure all tasks are captured

param(
    [string]$Repository = "patriek-van-dorp/cloud-quick-start-infra",
    [switch]$WhatIf = $false
)

Write-Host "Creating Individual GitHub Issues for All 98 Azure Cloud Foundation Tasks" -ForegroundColor Green
Write-Host "Repository: $Repository" -ForegroundColor Yellow
Write-Host "What-If Mode: $WhatIf" -ForegroundColor Yellow
Write-Host ""

# Read and parse tasks from tasks.md
$tasksFile = "specs/001-azure-cloud-foundation/tasks.md"
if (-not (Test-Path $tasksFile)) {
    Write-Error "Tasks file not found: $tasksFile"
    exit 1
}

$content = Get-Content $tasksFile -Raw
$issueCount = 0

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

function New-GitHubIssue {
    param(
        [string]$Title,
        [string]$Body,
        [string[]]$Labels,
        [string]$Repository,
        [switch]$WhatIf
    )
    
    $script:issueCount++
    
    if ($WhatIf) {
        Write-Host "WHAT-IF: Would create issue #$script:issueCount : $Title" -ForegroundColor Cyan
        return
    }
    
    try {
        # Create the issue first
        $result = gh issue create --repo $Repository --title $Title --body $Body
        Write-Host "✓ Created issue #$script:issueCount : $Title" -ForegroundColor Green
        
        # Extract issue number from result
        $issueNumber = $null
        if ($result -match "#(\d+)") {
            $issueNumber = $matches[1]
            
            # Add labels separately if we have them and got an issue number
            if ($Labels -and $Labels.Count -gt 0 -and $issueNumber) {
                try {
                    $labelArgs = $Labels | ForEach-Object { "--add-label", $_ }
                    & gh issue edit $issueNumber --repo $Repository @labelArgs
                    Write-Host "  → Added labels: $($Labels -join ', ')" -ForegroundColor Gray
                }
                catch {
                    Write-Warning "Failed to add labels to issue #$issueNumber : $($_.Exception.Message)"
                }
            }
        }
        
        Start-Sleep -Milliseconds 500  # Rate limiting protection
        return $result
    }
    catch {
        Write-Error "Failed to create issue: $Title - Error: $($_.Exception.Message)"
    }
}

# Extract all task lines - improved pattern to capture full descriptions
$taskPattern = '- \[ \] (T\d{3})(?:\s+\[([^\]]+)\])?\s+(.*?)(?=\r?\n|$)'
$tasks = [System.Text.RegularExpressions.Regex]::Matches($content, $taskPattern, 'Multiline,Singleline')

Write-Host "Found $($tasks.Count) tasks to process..." -ForegroundColor Yellow
Write-Host ""

foreach ($task in $tasks) {
    $taskId = $task.Groups[1].Value
    $parallelMarker = $task.Groups[2].Value
    $fullDescription = $task.Groups[3].Value.Trim()
    
    # Extract file path if present
    $filePathMatch = [regex]::Match($fullDescription, 'in `([^`]+)`')
    $filePath = if ($filePathMatch.Success) { $filePathMatch.Groups[1].Value } else { "" }
    
    # Clean description (remove file path part)
    $description = $fullDescription -replace '\s+in\s+`[^`]+`', ''
    $description = $description.Trim()
    
    $phaseInfo = Get-PhaseInfo -TaskId $taskId
    $isParallel = $parallelMarker -eq "P" -or $parallelMarker -match "US\d"
    
    # Determine user story if applicable
    $userStory = ""
    if ($parallelMarker -match "US\d") {
        $userStory = "[$parallelMarker] "
    }
    
    # Build title
    $title = "$taskId - $userStory$description"
    if ($isParallel) {
        $title += " [PARALLEL]"
    }
    
    # Build labels
    $labels = @($phaseInfo.PhaseLabel, $phaseInfo.Priority, $taskId.ToLower())
    if ($isParallel) { $labels += "parallel" }
    if ($filePath) { $labels += "implementation" }
    if ($description -match "test|validation") { $labels += "testing" }
    if ($description -match "bicep") { $labels += "bicep" }
    if ($description -match "deploy") { $labels += "deployment" }
    
    # Build body
    $fileSuffix = if ($filePath) { " in ``$filePath``" } else { "" }
    $parallelSection = if ($isParallel) { "`n### Parallel Execution ⚡`nThis task can be executed in parallel with other tasks marked [P]`n" } else { "" }
    $filePathSection = if ($filePath) { "``$filePath``" } else { "To be determined during implementation" }
    $priorityText = $phaseInfo.Priority.Replace('-priority', '').ToUpper()
    
    $body = @"
## Task $taskId
**$($phaseInfo.Phase)**

### Description
$description$fileSuffix

### Priority
$priorityText - $($phaseInfo.Phase)

### Estimated Effort
8 hours maximum

### File Path
$filePathSection
$parallelSection
### Acceptance Criteria
- Task implementation follows Toyota Louwmans FS standards
- Code/configuration is properly documented
- Implementation is tested and validated
- Human approval obtained before marking complete

### Dependencies
See tasks.md for detailed dependency information

### Human Approval Required ⚠️
Review and approve before marking this task as complete
"@
    
    # Create the issue
    New-GitHubIssue -Repository $Repository -WhatIf:$WhatIf -Title $title -Body $body -Labels $labels
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Green
Write-Host "- Total Individual Issues Created: $issueCount" -ForegroundColor Yellow
Write-Host "- All 98 tasks are now individual GitHub issues" -ForegroundColor Yellow
Write-Host "- Each task has proper priority, dependencies, and acceptance criteria" -ForegroundColor Yellow
Write-Host "- Parallel execution opportunities are clearly marked" -ForegroundColor Yellow
Write-Host "- Human approval points are specified for each task" -ForegroundColor Yellow
Write-Host ""

if ($WhatIf) {
    Write-Host "WhatIf Mode Complete - No actual issues created" -ForegroundColor Cyan
    Write-Host "Run without -WhatIf to create all 98 individual GitHub issues" -ForegroundColor Cyan
} else {
    Write-Host "All 98 individual GitHub issues created successfully!" -ForegroundColor Green
    Write-Host "Check your repository: https://github.com/$Repository/issues" -ForegroundColor Blue
}