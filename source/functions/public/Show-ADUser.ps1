Function Show-ADUser {
	<#
	.SYNOPSIS
	Shows ADUser Information.

	.DESCRIPTION
	Collects and displays certain information for an ADUser.

	.PARAMETER UserName
	SAMAccountName of the ADUser

	.EXAMPLE
	PS C:\> Show-ADUser -UserName janed

	This example gathers information about janed's account and displays it to the console.
	This function has an alias of 'sadu' so an alternate way of write this command is:

	PS C:\> sadu janed
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True, Position=1)][string]$UserName
	)

	Write-Verbose "[$UserName] Gathering Information"
	$ObjUser = Get-ADUser -Filter {samAccountName -eq $UserName} -Properties *

	If ($Null -eq $ObjUser) {
		Write-Warning "[$UserName] Does Not Exist"
	}

	[datetime]$today = (get-date)
	$PassAgeDays = ($today - $ObjUser.PasswordLastSet).Days
	$PassAgeHours = ($today - $ObjUser.PasswordLastSet).Hours
	$PassAgeMin = ($today - $ObjUser.PasswordLastSet).Minutes
	$PassAge = "$PassAgeDays Days $PassAgeHours Hours $PassAgeMin Minutes"
	$Props = [ordered]@{
		'DisplayName'     = $($ObjUser.DisplayName)
		'Company'         = $($ObjUser.Company)
		'Enabled'         = $($ObjUser.Enabled)
		'LockedOut'       = $($ObjUser.LockedOut)
		'PasswordExpired' = $($ObjUser.PasswordExpired)
		'PasswordLastSet' = $($ObjUser.PasswordLastSet)
		'PasswordAge'     = $PassAge
		'CreatedDated'    = $($ObjUser.whenCreated)
		'CanonicalName'   = $($ObjUser.CanonicalName)
		'LogonScript'     = $($ObjUser.ScriptPath)
		'ExpirationDate'  = $($ObjUser.AccountExpirationDate)
		'EmailAddress'    = $($ObjUser.mail)
		'Description'     = $($ObjUser.Description)
	}
	$Output = New-Object -TypeName PSObject -Property $Props
	Write-Output $Output
}
Set-Alias -Name sadu -Value Show-ADUser -Description 'Show Speicifc details of AD User Accounts'