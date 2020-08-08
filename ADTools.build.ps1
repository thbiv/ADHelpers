$Script:ModuleName = 'ADHelpers'
$Script:SourceRoot = "$BuildRoot\source"
$Script:OutputRoot = "$BuildRoot\_output"
$Script:TestResultsRoot = "$BuildRoot\_testresults"
$Script:FileHashRoot = "$BuildRoot\_filehash"
$Script:TestsRoot = "$BuildRoot\tests"
$Script:Manifest = Import-PowerShellDataFile -Path "$SourceRoot\$ModuleName.psd1"
$Script:Source_PSD1 = "$SourceRoot\$ModuleName.psd1"
$Script:Dest_PSD1 = "$OutputRoot\$ModuleName\$ModuleName.psd1"
$Script:Dest_PSM1 = "$OutputRoot\$ModuleName\$ModuleName.psm1"

Task . Clean, Build, Test, Hash, Deploy
Task Testing Clean, Build, Test

# Synopsis: Empty the _output and _testresults folders
Task Clean {
    If (Test-Path -Path $OutputRoot) {
        Get-ChildItem -Path $OutputRoot -Recurse | Remove-Item -Force -Recurse
    }
    If (Test-Path -Path $TestResultsRoot) {
        Get-ChildItem -Path $TestResultsRoot -Recurse | Remove-Item -Force -Recurse
    }
}

# Synopsis: Compile and build the project
Task Build {
    Write-Host "Building Powershell Module '$ModuleName' $($Manifest.ModuleVersion)"
    New-Item -Path "$OutputRoot\$ModuleName" -ItemType Directory -Force | Out-Null
    Write-Host "Compiling Private Functions"
    Get-ChildItem -Path "$SourceRoot\functions\Private" -file | ForEach-Object {
        $_ | Get-Content | Add-Content -Path $Dest_PSM1 -Force -Encoding ASCII
    }
    Write-Host "Compiling Public Functions"
    Get-ChildItem -Path "$SourceRoot\functions\Public" -File | ForEach-Object {
        $_ | Get-Content | Add-Content -Path  $Dest_PSM1 -Force -Encoding ASCII
    }
    Write-Host "Copying Module Manifest"
    Copy-Item -Path $Source_PSD1 -Destination $Dest_PSD1
}

# Synopsis: Test the Project
Task Test {
    $PesterPSSA = @{
        OutputFile = "$TestResultsRoot\PSSAResults.xml"
        OutputFormat = 'NUnitXml'
        Script = @{Path="$TestsRoot\PSSA.tests.ps1";Parameters=@{Path=$OutputRoot}}
    }
    $PSSAResults = Invoke-Pester @PesterPSSA -PassThru
    $PesterBasic = @{
        OutputFile = "$TestResultsRoot\BasicResults.xml"
        OutputFormat = 'NUnitXml'
        Script = @{Path="$TestsRoot\BasicModule.tests.ps1";Parameters=@{Path=$OutputRoot;ProjectName=$ModuleName}}
    }
    $BasicResults = Invoke-Pester @PesterBasic -PassThru
    Write-Host "Processing Pester Results"
    $FPesterParams = @{
        PesterResult = @($PSSAResults,$BasicResults)
        Path = "$TestResultsRoot"
        Format = 'HTML'
        Include = 'Passed','Failed'
        BaseFileName = "PesterResults_$ModuleName.$($Manifest.ModuleVersion)"
        ReportTitle = "Pester Results - $ModuleName - $($Manifest.ModuleVersion)"
    }
    Format-Pester @FPesterParams
    If ($PSSAResults.FailedCount -ne 0) {Throw "PSScriptAnalyzer Test Failed"}
    If ($BasicResults.FailedCount -ne 0) {Throw "Basic Test Failed"}
}

# Synopsis: Produce File Hash for all output files
Task Hash {
    $Files = Get-ChildItem -Path "$OutputRoot\$ModuleName" -File -Recurse
    $HashOutput = @()
    ForEach ($File in $Files) {
        $HashOutput += Get-FileHash -Path $File.fullname
    }
    $HashExportFile = "ModuleFiles_Hash_$ModuleName.$($Manifest.ModuleVersion).xml"
    $HashOutput | Export-Clixml -Path "$FileHashRoot\$HashExportFile"
}

#Synopsis: Deploy to SFGallery
Task Deploy {
    Invoke-PSDeploy -Force -Verbose
}