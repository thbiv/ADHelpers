Function Search-ADHObject {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True, Position=0)]
		[string]$Search,

		[Parameter(Mandatory=$False)]
		[string]$Server = $(Get-ADHServerValue),

		[Parameter(Mandatory=$True, ParameterSetName="User")]
		[switch]$User,

		[Parameter(Mandatory=$True, ParameterSetName="Computer")]
		[switch]$Computer,

		[Parameter(Mandatory=$True, ParameterSetName="Group")]
		[switch]$Group,

		[Parameter(Mandatory=$True, ParameterSetName="OU")]
		[switch]$OU
	)
	Write-Verbose "[$Search] Search Start"
	If ($User) {
		Write-Verbose "[$Search] User Accounts Start"
		$ADUParameters = @{
			LDAPFilter = "(SamAccountName=*$Search*)"
			Properties = '*'
		}
		If ($Server -ne "") {$ADUParameters.Add('Server',$Server)}
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
		If ($Server -ne "") {$ADCParameters.Add('Server',$Server)}
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
		If ($Server -ne "") {$ADGParameters.Add('Server',$Server)}
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
		If ($Server -ne "") {$ADOUParameters.Add('Server',$Server)}
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