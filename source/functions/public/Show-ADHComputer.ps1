Function Show-ADHComputer {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True,Position=0)]
        [string]$ComputerName,

        [Parameter(Mandatory=$False)]
        [string]$Server = $(Get-ADHServerValue)
    )

    Try {
        $Params1 = @{
            'Identity' = $ComputerName
            'Properties' = '*'
            'ErrorAction' = 'Stop'
        }
        If ($Server -ne "") {{$Params1.Add('Server',$Server)}}
        $Computer = Get-ADComputer @Params1
        $Laps = Get-AdmPwdPassword -ComputerName $ComputerName
        $BitLocker = Get-BitlockerRecovery -Name $ComputerName | Sort-Object Date -Descending | Select-Object -First 1
        If (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
            $Status = 'Online'
        } Else {
            $Status = 'Offline'
        }
        $Props = [ordered]@{
            'ComputerName' = $($Computer.Name)
            'FQDN' = $($Computer.DNSHostName)
            'Enabled' = $($Computer.Enabled)
            'Status' = $Status
            'Description' = $($Computer.Description)
            'CanonicalName' = $($Computer.CanonicalName)
            'CreatedDate' = $($Computer.whenCreated)
            'IPAddress' = $($Computer.IPv4Address)
            'OperatingSystem' = $($Computer.OperatingSystem)
            'LAPSPassword' = $($Laps.Password)
            'LAPSExpirationTime' = $($Laps.ExpirationTimeStamp)
            'BitLockerPasswordID' = $($BitLocker.PasswordID)
            'BitLockerRecoveryPassword' = $($BitLocker.RecoveryPassword)
        }
        $Output = New-Object -TypeName PSObject -Property $Props
        Write-Output $Output
    } Catch {
        $ErrorMessage = $_.exception.message
        Write-Warning "$ErrorMessage"
    }
}
Set-Alias -Name sadc -Value Show-ADComputer -Description 'Show Speicifc details of AD Computers Accounts'