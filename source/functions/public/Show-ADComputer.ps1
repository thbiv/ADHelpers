Function Show-ADComputer {
    <#
    .SYNOPSIS
        Shows ADComputer Information
    .DESCRIPTION
        Collects information about the computer object including LAPS and BitLocker information.
        Will also perform a simple online/offline check.
    .PARAMETER ComputerName
        Name of the computer to return data for.
    .EXAMPLE
        PS C:\> Show-ADComputer -ComputerName computer1
        PS C:\> Show-ADComputer computer1
        PS C:\> sadc computer1

        All 3 of these commands in this example will return information for a computer named 'computer1'
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True,Position=0)]
        [string]$ComputerName
    )

    Try {
        $Computer = Get-ADComputer -Identity $ComputerName -Properties * -ErrorAction STOP
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