Function Export-ADHUserSecurityGroup {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$True,Position=0)]
		[string]$User,

		[Parameter(Mandatory=$False)]
		[string]$Server = $(Get-ADHServerValue),

		[Parameter(Mandatory=$False)]
		[string]$OutputPath = $(Get-ADHTermOutputPathValue)
	)
	If ($OutputPath -ne "") {
		Write-Verbose "[$User] Script Start"
		Write-Verbose "[$User] OutputPath: $OutputPath"
		Write-Verbose "[$User] Gathering Data..."
		$Params1 = @{
			'Identity' = $User
			'Properties' = 'MemberOf'
		}
		If ($Server -ne "") {{$Params1.Add('Server',$Server)}}
		$GroupDNList = (Get-ADUser @Params1 | Select-Object MemberOf).MemberOf
		$GroupDNList = $GroupDNList | Sort-Object
		$Params2 = @{
			'Filter' = {samAccountName -eq $User}
			'Properties' = '*'
		}
		If ($Server -ne "") {{$Params2.Add('Server',$Server)}}
		$UserProps = Get-ADUser @Params2 | Select-Object DisplayName,Description,whenCreated,Department,EmployeeID,Manager
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
			$Params3 = @{
				'Identity' = $Line
				'Properties' = '*'
			}
			If ($Server -ne "") {{$Params3.Add('Server',$Server)}}
			$Type = (Get-ADGroup $Params3 | Select-Object groupType).groupType
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
	} Else {
		Throw "The OutputPath parameter was not given a value. Please retry your command"
	}
}