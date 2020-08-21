Function Get-ADHTermOutputPathValue {
    If ($ADH_TermOutputPath) {
        $Output = $ADH_TermOutputPath
    } Else {
        $ConfigPath = $(Get-ADHConfigPath)
        If (Test-Path -Path $ConfigPath) {
            $Config = Import-PowerShellDataFile -Path $ConfigPath
            If ($Config.TermOutputPath) {
                $Output = $Config.TermOutputPath
            } Else {
                $Output = ""
            }
        } Else {
            $Output = ""
        }
    }
    Write-Output $Output
}