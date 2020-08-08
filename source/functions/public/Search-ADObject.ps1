Function Search-ADObject {
	<#
	.SYNOPSIS
		Function for searching different AD Objects.

	.DESCRIPTION
		Function for searching different AD Objects. Will let you search user objects,
		computer objects, security groups, and organizational units. You can only
		search for one object type at a time.

	.PARAMETER Search
		Specifies the search string the function will use.

	.PARAMETER User
		Will list all user accounts that contain the search string.

	.PARAMETER Computer
		Will list all computer accounts that contain the search string.

	.PARAMETER Group
		Will list all security groups that contain the search string.

	.PARAMETER OU
		Will listall organizational units that contain the search string.

	.EXAMPLE
	PS C:\> Search-ADObject -Search jane -User

	This example will search ActiveDirectory for any usernames that contain 'jane'.

	.EXAMPLE
	PS C:\> Search-ADObject -Search abcd -Computer

	This example will search ActiveDirectory for any computernames that contain 'abcd'.

	.NOTES
		Written by Thomas Barratt
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True, Position=0)][string]$Search,
		[Parameter(Mandatory=$True, ParameterSetName="User")][switch]$User,
		[Parameter(Mandatory=$True, ParameterSetName="Computer")][switch]$Computer,
		[Parameter(Mandatory=$True, ParameterSetName="Group")][switch]$Group,
		[Parameter(Mandatory=$True, ParameterSetName="OU")][switch]$OU
	)
	Write-Verbose "[$Search] Search Start"
	If ($User) {
		Write-Verbose "[$Search] User Accounts Start"
		$ADUParameters = @{
			LDAPFilter = "(SamAccountName=*$Search*)"
			Properties = '*'
		}
		$objUser = @()
		ForEach ($obj in (Get-ADUser @ADUParameters)) {
			$OneObj = New-Object PSObject
			$OneObj | Add-Member -MemberType NoteProperty -Name SamAccountName -Value $obj.SamAccountName
			$OneObj | Add-Member -MemberType NoteProperty -Name DisplayName -Value $obj.DisplayName
			$OneObj | Add-Member -MemberType NoteProperty -Name Enabled -Value $obj.Enabled
			$OneObj | Add-Member -MemberType NoteProperty -Name CanonicalName -Value $obj.CanonicalName
			Write-Verbose "[$Search][User] User Found: $($obj.DisplayName)"
			$objUser += $OneObj
		}
		Write-Verbose "[$Search] User Accounts End"
		Write-Output $objUser
	}
	If ($Computer) {
		Write-Verbose "[$Search] Computer Accounts Start"
		$ADCParameters = @{
			LDAPFilter = "(SamAccountName=*$Search*)"
			Properties = '*'
		}
		$objComputer = @()
		ForEach ($obj in (Get-ADComputer @ADCParameters)) {
			$OneObj = New-Object PSObject
			$OneObj | Add-Member -MemberType NoteProperty -Name	Name -Value $obj.Name
			$OneObj | Add-Member -MemberType NoteProperty -Name	Enabled -Value $obj.Enabled
			$OneObj | Add-Member -MemberType NoteProperty -Name	CanonicalName -Value $obj.CanonicalName
			Write-Verbose "[$Search][Computer] Computer Found: $($obj.Name)"
			$objComputer += $OneObj
		}
		Write-Verbose "[$Search] Computer Accounts End"
		Write-Output $objComputer
	}
	If ($Group) {
		Write-Verbose "[$Search] Groups Start"
		$ADGParameters = @{
			LDAPFilter = "(name=*$Search*)"
			Properties = '*'
		}
		$objGroup = @()
		ForEach ($obj in (Get-ADGroup @ADGParameters)) {
			$OneObj = New-Object PSObject
			$OneObj | Add-Member -MemberType NoteProperty -Name	Name -Value $obj.Name
			$OneObj | Add-Member -MemberType NoteProperty -Name	CanonicalName -Value $obj.CanonicalName
			Write-Verbose "[$Search][Group] Group Found: $($obj.Name)"
			$objGroup += $OneObj
		}
		Write-Verbose "[$Search] Groups End"
		Write-Output $objGroup
	}
	If ($OU) {
		Write-Verbose "[$Search] OU Start"
		$ADOUParameters = @{
			LDAPFilter = "(name=*$Search*)"
		}
		$objOU = @()
		ForEach ($obj in (Get-ADOrganizationalUnit @ADOUParameters)) {
			$OneObj = New-Object PSObject
			$OneObj | Add-Member -MemberType NoteProperty -Name	Name -Value $obj.Name
			$OneObj | Add-Member -MemberType NoteProperty -Name	DistinguishedName -Value $obj.DistinguishedName
			Write-Verbose "[$Search][OU] OU Found: $($obj.Name)"
			$objOU += $OneObj
		}
		Write-Verbose "[$Search] OU End"
		Write-Output $objOU
	}
	Write-Verbose "[$Search] Search End"
}
Set-Alias -Name search -Value Search-ADObject -Description 'Search User, Computer, Group, OU objects'