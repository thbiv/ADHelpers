Function Get-ADHServerValue {
    $ConfigPath = $(Get-ADHConfigPath)
    If (Test-Path -Path $ConfigPath) {
        $Config = Import-PowerShellDataFile -Path $ConfigPath
        $Output = $Config.Server
    } Else {
        $Output = $Null
    }
}