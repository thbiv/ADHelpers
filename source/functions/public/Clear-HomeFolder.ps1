Function Clear-HomeFolder {
	<#
	.SYNOPSIS
	Clears the home folder attributes from an AD user account. Can also delete the home folder itself.

	.DESCRIPTION
	Clears the home folder attributes from an AD user account. Can also delete the home folder itself.

	.PARAMETER User
	The username of the user to clear the attributes from.

	.PARAMETER DeleteHomeFolder
	If used, the function will delete the folder that is in the HomeDirectory attribute of the AD user account.

	.EXAMPLE
	PS C:\> Clear-HomeFolder -User janed

	This example will clear the HomeDrive and HomeDirectory attributes of the account for 'janed'

	.EXAMPLE
	PS C:\> Clear-HomeFolder -User janed -DeleteHomeFolder

	This example does the same as example 1 but will also attempt to delete the folder that was in the HomeDirectory attribute.
	#>

	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$True,Position=1)][string[]]$User,
		[string]$Server = $(Get-ADHServerValue),
		[switch]$DeleteHomeFolder
	)

	Write-Verbose 'Finding Config File'
	$ConfigPath = "$PSScriptRoot\ADTools.Config.psd1"
	If (-not(Test-Path -Path $ConfigPath)) {
		$ConfigPath = (Resolve-Path -Path "$PSScriptRoot\..\..\ADTools.Config.psd1").Path
	} Else {
		Throw "No Config File was found"
	}
	Write-Verbose "Config File: $ConfigFile"
	Write-Verbose 'Importing Config File'
	$ADTools = Import-PowerShellDataFile -Path $ConfigPath

	Write-Verbose 'Setting Variables from Config File'
	$Server = $($ADTools.config.defaultserver)

	ForEach ($Obj in $User) {
		$HomeFolder = Get-ADUser -Identity $Obj -Server $Server -Properties HomeDirectory | Select-Object -ExpandProperty HomeDirectory
		Try {
			Get-ADUser -Identity $User -Server $Server -Properties HomeDirectory, HomeDrive | Set-ADUser -Clear HomeDirectory, HomeDrive -Server $Server
			Write-Verbose "[$Obj] Cleared Home Folder AD Attributes"
		}
		Catch {
			$ErrorMessage = $_.Exception.Message
			Write-Warning "[$Obj] $ErrorMessage"
		}
		If ($DeleteHomeFolder) {
			Remove-FilesOverPathLimit -Destination $HomeFolder
			Remove-Item -Path $HomeFolder -Recurse -Force
			Write-Verbose "[$Obj] Deleted: $HomeFolder"
		}
	}
}