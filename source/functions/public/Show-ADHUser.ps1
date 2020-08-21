Function Show-ADHUser {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True, Position=1)]
		[string]$UserName,

		[Parameter(Mandatory=$False)]
		[string]$Server = $(Get-ADHServerValue)
	)

	Write-Verbose "[$UserName] Gathering Information"
	$Params1 = @{
		'Filter' = {samAccountName -eq $UserName}
		'Propertis' = '*'
	}
	If ($Server -ne "") {{$Params1.Add('Server',$Server)}}
	$ObjUser = Get-ADUser @Params1

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