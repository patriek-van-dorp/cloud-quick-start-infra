# Prerequisites Validation Script
# Validates development environment setup and tool versions

param(
    [switch]$Json
)

$ErrorActionPreference = "Stop"

# Required tools and minimum versions
$requiredTools = @(
    @{
        Name = "Azure CLI"
        Command = "az"
        Args = @("--version")
        MinVersion = "2.50.0"
        VersionPattern = "azure-cli\s+([0-9]+\.[0-9]+\.[0-9]+)"
    },
    @{
        Name = "Azure PowerShell"
        Command = "pwsh"
        Args = @("-Command", "`$PSVersionTable.PSVersion.ToString()")
        MinVersion = "7.0.0"
        VersionPattern = "([0-9]+\.[0-9]+\.[0-9]+)"
    },
    @{
        Name = "Bicep CLI"
        Command = "bicep"
        Args = @("--version")
        MinVersion = "0.20.0"
        VersionPattern = "([0-9]+\.[0-9]+\.[0-9]+)"
    },
    @{
        Name = "Git"
        Command = "git"
        Args = @("--version")
        MinVersion = "2.30.0"
        VersionPattern = "git version ([0-9]+\.[0-9]+\.[0-9]+)"
    }
)

$validationResults = @()
$allValid = $true

Write-Host "Validating development environment prerequisites..." -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan

foreach ($tool in $requiredTools) {
    try {
        $process = Start-Process -FilePath $tool.Command -ArgumentList $tool.Args -NoNewWindow -PassThru -RedirectStandardOutput "temp_output.txt" -RedirectStandardError "temp_error.txt"
        $process.WaitForExit()

        if ($process.ExitCode -eq 0) {
            $output = Get-Content "temp_output.txt" -Raw
            $versionMatch = [regex]::Match($output, $tool.VersionPattern)

            if ($versionMatch.Success) {
                $version = $versionMatch.Groups[1].Value
                $isValidVersion = [version]$version -ge [version]$tool.MinVersion

                if ($isValidVersion) {
                    Write-Host "✓ $($tool.Name) v$version (≥ $($tool.MinVersion))" -ForegroundColor Green
                    $validationResults += @{
                        Tool = $tool.Name
                        Status = "PASS"
                        Version = $version
                        Required = $tool.MinVersion
                        Installed = $true
                    }
                } else {
                    Write-Host "✗ $($tool.Name) v$version (< $($tool.MinVersion) required)" -ForegroundColor Red
                    $validationResults += @{
                        Tool = $tool.Name
                        Status = "FAIL"
                        Version = $version
                        Required = $tool.MinVersion
                        Installed = $true
                        Message = "Version too old"
                    }
                    $allValid = $false
                }
            } else {
                Write-Host "✓ $($tool.Name) (installed, version unknown)" -ForegroundColor Yellow
                $validationResults += @{
                    Tool = $tool.Name
                    Status = "WARN"
                    Version = "unknown"
                    Required = $tool.MinVersion
                    Installed = $true
                    Message = "Version pattern not matched"
                }
            }
        } else {
            $errorOutput = Get-Content "temp_error.txt" -Raw
            Write-Host "✗ $($tool.Name) (not found or failed)" -ForegroundColor Red
            $validationResults += @{
                Tool = $tool.Name
                Status = "FAIL"
                Version = $null
                Required = $tool.MinVersion
                Installed = $false
                Message = "Command failed: $errorOutput"
            }
            $allValid = $false
        }
    } catch {
        Write-Host "✗ $($tool.Name) (not found)" -ForegroundColor Red
        $validationResults += @{
            Tool = $tool.Name
            Status = "FAIL"
            Version = $null
            Required = $tool.MinVersion
            Installed = $false
            Message = "Exception: $($_.Exception.Message)"
        }
        $allValid = $false
    } finally {
        # Clean up temp files
        if (Test-Path "temp_output.txt") { Remove-Item "temp_output.txt" }
        if (Test-Path "temp_error.txt") { Remove-Item "temp_error.txt" }
    }
}

# Check for Azure PowerShell module specifically
try {
    $azModule = Get-Module -Name Az -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1
    if ($azModule) {
        $version = $azModule.Version.ToString()
        $isValidVersion = [version]$version -ge [version]"9.0.0"

        if ($isValidVersion) {
            Write-Host "✓ Azure PowerShell Module v$version (≥ 9.0.0)" -ForegroundColor Green
            $validationResults += @{
                Tool = "Azure PowerShell Module"
                Status = "PASS"
                Version = $version
                Required = "9.0.0"
                Installed = $true
            }
        } else {
            Write-Host "✗ Azure PowerShell Module v$version (< 9.0.0 required)" -ForegroundColor Red
            $validationResults += @{
                Tool = "Azure PowerShell Module"
                Status = "FAIL"
                Version = $version
                Required = "9.0.0"
                Installed = $true
                Message = "Version too old"
            }
            $allValid = $false
        }
    } else {
        Write-Host "✗ Azure PowerShell Module (not installed)" -ForegroundColor Red
        $validationResults += @{
            Tool = "Azure PowerShell Module"
            Status = "FAIL"
            Version = $null
            Required = "9.0.0"
            Installed = $false
            Message = "Module not found"
        }
        $allValid = $false
    }
} catch {
    Write-Host "✗ Azure PowerShell Module (check failed)" -ForegroundColor Red
    $validationResults += @{
        Tool = "Azure PowerShell Module"
        Status = "FAIL"
        Version = $null
        Required = "9.0.0"
        Installed = $false
        Message = "Exception: $($_.Exception.Message)"
    }
    $allValid = $false
}

Write-Host ("=" * 60) -ForegroundColor Cyan

if ($allValid) {
    Write-Host "Prerequisites validation: PASS" -ForegroundColor Green
    Write-Host "All required tools are installed with correct versions." -ForegroundColor Green

    if ($Json) {
        $output = @{
            Status = "PASS"
            Message = "All required tools are installed with correct versions"
            Results = $validationResults
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }
        $output | ConvertTo-Json -Depth 3
    }

    exit 0
} else {
    Write-Host "Prerequisites validation: FAIL" -ForegroundColor Red
    Write-Host "Some required tools are missing or have incorrect versions." -ForegroundColor Red
    Write-Host "Please install/update the missing tools before proceeding." -ForegroundColor Red

    if ($Json) {
        $output = @{
            Status = "FAIL"
            Message = "Some required tools are missing or have incorrect versions"
            Results = $validationResults
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }
        $output | ConvertTo-Json -Depth 3
    }

    exit 1
}