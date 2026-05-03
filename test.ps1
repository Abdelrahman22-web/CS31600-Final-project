# Test script for topological sorting project (Windows PowerShell)
# Run: powershell -ExecutionPolicy Bypass -File .\test.ps1

$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Join-Path $scriptRoot "topological_sorting_project"
$javaRoot = Join-Path $projectRoot "java"
$sampleRoot = Join-Path $projectRoot "samples"

function Run-JavaSample([string]$sampleFile) {
    $samplePath = Join-Path $sampleRoot $sampleFile
    Write-Host "Input file: $samplePath" -ForegroundColor Gray
    Get-Content $samplePath | & java Main
    if ($LASTEXITCODE -ne 0) {
        throw "Java run failed for sample: $sampleFile"
    }
}

function Run-SmlSample([string]$sampleFile) {
    $samplePath = Join-Path $sampleRoot $sampleFile
    Write-Host "Input file: $samplePath" -ForegroundColor Gray
    Get-Content $samplePath | & sml "sml/TopoSort.sml"
    if ($LASTEXITCODE -ne 0) {
        throw "SML run failed for sample: $sampleFile"
    }
}

Write-Host "=== Topological Sorting Project Test Suite ===" -ForegroundColor Cyan
Write-Host ""

try {
    Write-Host "Testing Java implementation..." -ForegroundColor Yellow
    Push-Location $javaRoot
    try {
        Write-Host "Compiling Java files..." -ForegroundColor Gray
        & javac *.java
        if ($LASTEXITCODE -ne 0) {
            throw "Java compilation failed."
        }

        Write-Host ""
        Write-Host "Test 1: Java acyclic graph" -ForegroundColor Yellow
        Run-JavaSample "acyclic.txt"

        Write-Host ""
        Write-Host "Test 2: Java cyclic graph" -ForegroundColor Yellow
        Run-JavaSample "cyclic.txt"

        Write-Host ""
        Write-Host "=== Java tests passed ===" -ForegroundColor Green
    } finally {
        Write-Host ""
        Write-Host "Cleaning up compiled Java files..." -ForegroundColor Gray
        Get-ChildItem -Path . -Filter "*.class" -File | Remove-Item -Force -ErrorAction SilentlyContinue
        Pop-Location
    }

    $smlCommand = Get-Command sml -ErrorAction SilentlyContinue
    if ($null -eq $smlCommand) {
        Write-Host ""
        Write-Host "SML/NJ not found on PATH; skipping SML tests." -ForegroundColor DarkYellow
    } else {
        Write-Host ""
        Write-Host "Testing SML implementation..." -ForegroundColor Yellow
        Push-Location $projectRoot
        try {
            Write-Host ""
            Write-Host "Test 3: SML acyclic graph" -ForegroundColor Yellow
            Run-SmlSample "acyclic.txt"

            Write-Host ""
            Write-Host "Test 4: SML cyclic graph" -ForegroundColor Yellow
            Run-SmlSample "cyclic.txt"

            Write-Host ""
            Write-Host "=== SML tests passed ===" -ForegroundColor Green
        } finally {
            Pop-Location
        }
    }

    Write-Host ""
    Write-Host "All tests completed successfully!" -ForegroundColor Green
    exit 0
} catch {
    Write-Host ""
    Write-Host "Test suite failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
