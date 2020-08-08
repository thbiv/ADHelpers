Function Invoke-LockoutStatus {
	<#
	.SYNOPSIS
		A function for getting and dealing with locked AD user accounts.

	.DESCRIPTION
		The Get-LockoutStatus function can retrieve an AD User account's locked status from all domain controllers as well as
		unlock the account from all domain controllers.

	.PARAMETER UserName
		The username of the AD user account to get the status for or unlock.

	.PARAMETER LockoutStatus
		Retrieves the lock status of a user account from all writable domain controllers.

	.PARAMETER Unlock
		Will unlock a user account from all writable domain controllers.

	.PARAMETER Locked
		Gathers all Locked user accounts from all Domain controllers and groups the output by the username.

	.PARAMETER LockedDC
		Used with the 'Locked' switch to only gather information from one domain controller.

	.EXAMPLE
		PS C:\> Get-LockoutStatus -UserName janed -LockoutStatus

		This example will get the lock status of the user account janed from all domain controllers.

	.EXAMPLE
		PS C:\> Get-LockoutStatus -UserName janed -Unlock

		This example will unlock the janed user account from all domain controllers.

	.EXAMPLE
		PS C:\> Get-LockoutStatus -Locked

		This example will get all locked accounts from all domain controllers, then group then by the username.

	.EXAMPLE
		PS C:\> (Get-LockoutStatus -Locked).Group

		This example does the same as the previous example except that it will not group by the username but will list all locked account for all domain controllers.

	.EXAMPLE
		PS C:\> Get-LockoutStatus -Locked -LockedDC myservername

		This example will get all locked account from only 1 domain controller.

	.NOTES
		Written by Thomas Barratt
	#>
	[CmdletBinding()]
	Param(
		[Parameter(Position=0,Mandatory=$True,ParameterSetName="User")][string]$UserName,
		[Parameter(ParameterSetName="User")][switch]$LockoutStatus,
		[Parameter(ParameterSetName="User")][switch]$Unlock,
		[Parameter(ParameterSetName="Locked")][switch]$Locked,
		[Parameter(ParameterSetName="Locked")][string]$LockedDC
	)
	$AD_DomainControllers = Get-ADDomainController -filter {isReadOnly -eq $False} | Select-Object -ExpandProperty HostName
	Write-Verbose "[START] Script Start"
	If ($LockoutStatus) {
		Write-Verbose "[$UserName] Lockout Status Start"
		$UserInfo = Get-ADUser $UserName -Properties SAMAccountName,DisplayName
		Write-Verbose "Lockout Status for: $($UserInfo.DisplayName) :: $($UserInfo.SAMAccountName)"
		$LockoutObj = @()
		ForEach ($Controller in $AD_DomainControllers) {
			Write-Verbose "[$UserName][LockOutStatus] Checking on: $Controller"
			$Server = ($Controller.Split('.'))[0]
			If ((Test-Connection -ComputerName $Server -Count 1 -Quiet) -eq $True) {
				$User = Get-ADUser $UserName -Properties * -Server $Controller
				$Props = @{
					'Server'=$Server;
					'LockedOut'=$($User.LockedOut)
					'AccountLockoutTime'=$($User.AccountLockoutTime);
					'badPwdCount'=$($User.badPwdCount);
					'LastBadPasswordAttempt'=$($User.LastBadPasswordAttempt);
				}
				$Obj = New-Object -TypeName psobject -Property $Props
				$LockoutObj += $Obj
				Write-Verbose "[$UserName][LockOutStatus][$Controller] Add to Output: $($Obj.LockedOut) | $($Obj.AccountLockoutTime) | $Obj.badPwdCount | $Obj.LastBadPasswordAttempt"
			}
			Else {
				Write-Verbose "[$UserName][LockOutStatus][$Controller] Server Not Accessible"
			}
		}
		$LockoutObj = $LockoutObj | Sort-Object Server | Select-Object Server,LockedOut,AccountLockoutTime,badPwdCount,LastBadPasswordAttempt
		Write-Verbose "[$UserName] Lockout Status End"
		Write-Output $LockoutObj | Format-Table -AutoSize
	}
	ElseIf ($Unlock) {
		Write-Verbose "[$UserName] Account Unlock Start"
		$ObjUser = Get-ADUser -Filter {samAccountName -eq $UserName}
		If ($Null -eq $ObjUser) {
			Throw "User account $UserName does not exist"
		}
		ForEach ($Object in $AD_DomainControllers) {
			$Server = ($Object.Split('.'))[0]
			If ((Test-Connection -ComputerName $Server -Count 1 -Quiet) -eq $True) {
				Write-Verbose "[$UserName][AccountUnlock] Unlocking account on $Server"
				Unlock-ADAccount -Identity $UserName -Server $Object
			}
			Else {
				Write-Verbose "[$UserName][AccountUnlock] Server Not Accessible: $Server"
			}
		}
		Write-Verbose "[$UserName] Account Unlock End"
	}
	ElseIf ($Locked) {
		Write-Verbose "[LockedAccounts] Locked Accounts Start"
		If ($LockedDC) {
			Write-Verbose "[LockedAccounts][LockedDC] '$LockedDC'"
			If ((Test-Connection -ComputerName $LockedDC -Count 1 -Quiet) -eq $True) {
				$AD_DomainControllers = $LockedDC
			}
			Else {
				Write-Verbose "[LockedAccounts][LockedDC] Server Not Accessible: $LockedDC"
			}
		}
		$LockedUsers = @()
		ForEach ($Object in $AD_DomainControllers) {
			$Server = ($Object.Split('.'))[0]
			Write-Verbose "[LockedAccounts] Checking on: $Server"
			If ((Test-Connection -ComputerName $Server -Count 1 -Quiet) -eq $True) {
				$LockedAccounts = Search-ADAccount -Server $Object -LockedOut -UsersOnly | Where-Object {$_.Enabled -eq $True}
				ForEach ($Lock in $LockedAccounts) {
					$User = Get-ADUser $Lock -Properties SAMAccountName,DisplayName
					$Props = @{
						'LogonID'=$($User.SAMAccountName);
						'DisplayName'=$($User.DisplayName);
						'Server'=$Server;
					}
					$Obj = New-Object -TypeName PSObject -Property $Props
					Write-Verbose "[LockedAccounts][$Server] Add to Output: $($Obj.LogonID) | $($Obj.DisplayName) | $($Obj.Server)"
					$LockedUsers += $Obj
				}
			}
			Else {
				Write-Verbose "[LockedAccounts][$Server] Server Not Accessible"
			}
		}
		Write-Verbose "[LockedAccounts] Locked Accounts End"
		$Output = @()
		ForEach ($Object in $AD_DomainControllers) {
            $Server = ($Object.Split('.'))[0]
            $FilteredUsers = $LockedUsers | Where-Object {$_.Server -eq $Server} | Sort-Object -Property DisplayName
            ForEach ($FilteredUser in $FilteredUsers) {
				$Props = @{
					'Server' = $Server
					'DisplayName' = $($FilteredUser.DisplayName)
					'LogonID' = $($FilteredUser.LogonID)
				}
				$Obj = New-Object -TypeName PSObject -Property $Props
				$Output += $Obj
            }
		}
		Write-Output $Output
	}
	Else {
		Write-Verbose "[$UserName] No switches Given"
		Throw "No action switches were used when calling the cmdlet. Please re-run the cmdlet using at least one switch. For more information, use Get-Help Invoke-LockoutStatus -Full."
	}
	Write-Verbose "[END] Script End"
}
Set-Alias -Name los -Value Invoke-LockoutStatus -Description 'Invoke LockoutStatus function'