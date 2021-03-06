Function Get-ADHServerValue {
    If ($ADH_Server) {
        $Output = $ADH_Server
    } Else {
        $ConfigPath = $(Get-ADHConfigPath)
        If (Test-Path -Path $ConfigPath) {
            $Config = Import-PowerShellDataFile -Path $ConfigPath
            If ($Config.Server) {
                $Output = $Config.Server
            } Else {
                $Output = ""
            }
        } Else {
            $Output = ""
        }
    }
    Write-Output $Output
}