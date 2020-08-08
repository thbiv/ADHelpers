Function Export-UserSecurityGroup {
	<#
	.SYNOPSIS
		Exports security groups and other data for an AD User Account to Excel format and saves to a folder.

	.DESCRIPTION
		Exports security groups and other data for an AD User Account to Excel format and saves to a folder.
		Requires the ActiveDirectory and ExcelPSLib modules

	.PARAMETER User
		The Logon ID of the account to export.

	.EXAMPLE
		PS C:\> Export-UserSecurityGroups -User janed

		This example will export the security groups of an account with a logonid of janed to the default output path.

	.LINK
		https://www.powershellgallery.com/packages/ExcelPSLib/0.6.6

	.LINK
		https://excelpslib.codeplex.com/

	.LINK
		http://epplus.codeplex.com/

	.NOTES
		Written by Thomas Barratt
	#>
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$True,Position=0)][string]$User
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
	$OutputPath = $($ADTools.config.termoutputpath)

	Write-Verbose "[$User] Script Start"
	Write-Verbose "[$User] OutputPath: $OutputPath"
	Write-Verbose "[$User] Gathering Data..."
	$GroupDNList = (Get-ADUser -Identity $user -Properties MemberOf | Select-Object MemberOf).MemberOf
	$GroupDNList = $GroupDNList | Sort-Object
	$UserProps = Get-ADUser -Filter {samAccountName -eq $user} -Properties * | Select-Object DisplayName,Description,whenCreated,Department,EmployeeID,Manager
	$Manager = ($($UserProps.Manager) -split ",*..=")[1]
	$FileName = "{0}_{1:yyyyMMdd}.xlsx" -f $($UserProps.DisplayName),$(Get-Date)
	Write-Verbose "[$User] Output Filename: $FileName"
	Write-Verbose "[$User] Start Building Excel Document"
	[OfficeOpenXml.ExcelPackage]$ObjExcel = New-OOXMLPackage -author "Powershell" -title "SecurityGroups"
	Write-Verbose "[$User][ExcelDocument] Title: SecurityGroups"
	[OfficeOpenXml.ExcelWorkbook]$xWorkBook = $ObjExcel | Get-OOXMLWorkbook
	$ObjExcel | Add-OOXMLWorksheet -WorkSheetName "Groups"
	Write-Verbose "[$User][ExcelDocument] WorksheetName: Groups"
	$xWorkSheetGroups = $xWorkBook | Select-OOXMLWorkSheet -WorkSheetName "Groups"
	$StyleHeader = New-OOXMLStyleSheet -WorkBook $xWorkBook -Name "Header" -Bold
	$xWorkSheetGroups | Set-OOXMLRangeValue -Row 1 -Col 1 -Value "Name" -StyleSheet $StyleHeader | Out-Null
	$xWorkSheetGroups | Set-OOXMLRangeValue -Row 2 -Col 1 -Value $($UserProps.DisplayName) | Out-Null
	Write-Verbose "[$User][ExcelDocument][AddData] Name: $($UserProps.DisplayName)"
	$xWorkSheetGroups | Set-OOXMLRangeValue -Row 2 -Col 3 -Value "Employee ID" -StyleSheet $StyleHeader | Out-Null
	$xWorkSheetGroups | Set-OOXMLRangeValue -Row 2 -Col 4 -Value $($UserProps.EmployeeID) | Out-Null
	Write-Verbose "[$User][ExcelDocument][AddData] EmployeeID: $($UserProps.EmployeeID)"
	$xWorkSheetGroups | Set-OOXMLRangeValue -Row 3 -Col 3 -Value "Description" -StyleSheet $StyleHeader | Out-Null
	$xWorkSheetGroups | Set-OOXMLRangeValue -Row 3 -Col 4 -Value $($UserProps.Description) | Out-Null
	Write-Verbose "[$User][ExcelDocument][AddData] Description: $($UserProps.Description)"
	$xWorkSheetGroups | Set-OOXMLRangeValue -Row 4 -Col 3 -Value "Manager" -StyleSheet $StyleHeader | Out-Null
	$xWorkSheetGroups | Set-OOXMLRangeValue -Row 4 -Col 4 -Value $($Manager) | Out-Null
	Write-Verbose "[$User][ExcelDocument][AddData] Manager: $($Manager)"
	$xWorkSheetGroups | Set-OOXMLRangeValue -Row 5 -Col 3 -Value "Department" -StyleSheet $StyleHeader | Out-Null
	$xWorkSheetGroups | Set-OOXMLRangeValue -Row 5 -Col 4 -Value $($UserProps.Department) | Out-Null
	Write-Verbose "[$User][ExcelDocument][AddData] Department: $($UserProps.Department)"
	$xWorkSheetGroups | Set-OOXMLRangeValue -Row 4 -Col 1 -Value "Member Of" -StyleSheet $StyleHeader | Out-Null
	$Row = 5
	ForEach ($line in $GroupDNList) {
		$Group = ($line -split ",*..=")[1]
		$Type = (Get-ADGroup -Identity $line -Properties * | Select-Object groupType).groupType
		Switch ($Type) {
			"8" {$TypeName = "Dist List-Universal"}
			"-2147483640" {$TypeName = "Security Group-Universal"}
			"2" {$TypeName = "Dist List-Global"}
			"-2147483646" {$TypeName = "Security Group-Global"}
			"4" {$TypeName = "Dist List-Domain Local"}
			"-2147483644" {$TypeName = "Security Group-Domain Local"}
			default {$TypeName = "Not Available"}
		}
		$xWorkSheetGroups | Set-OOXMLRangeValue -Row $Row -Col 1 -Value $Group | Out-Null
		$xWorkSheetGroups | Set-OOXMLRangeValue -Row $Row -Col 2 -Value $TypeName | Out-Null
		Write-Verbose "[$User][ExcelDocument][AddData] $Group | $TypeName"
		$Row++
	}
	1..3 | ForEach-Object {$xWorkSheetGroups.Column($_).AutoFit()}
	Write-Verbose "[$User] Script End"
	$ObjExcel | Save-OOXMLPackage -FileFullPath $(Join-Path -Path $OutputPath -ChildPath $FileName) -Dispose
}