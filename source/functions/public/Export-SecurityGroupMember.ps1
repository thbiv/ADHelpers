Function Export-SecurityGroupMember {
	<#
	.SYNOPSIS
	Exports security group members to an XLSX file alone with other information about the security group.

	.DESCRIPTION
	Exports security group members to an XLSX file alone with other information about the security group.

	.PARAMETER Group
	Name of the security group to be exported.

	.EXAMPLE
	PS C:\> Export-SecurityGroupMember -Group 'Domain Admins'

	This example will take information from the Domain Admins security group and create an XLSX file with that data.
	#>
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$True,Position=1)][string]$Group
	)
	Write-Verbose "[$Group] Getting group members"
	$GroupMembers = Get-ADGroupMember $Group
	Write-Verbose "[$Group] Geting properties"
	$GroupObject = Get-ADGroup $Group -Properties *
	Write-Verbose "[$Group] Creating new Excel object"
	$objExcel = New-Object -ComObject "Excel.Application"
	Write-Verbose "[$Group] Creating Excel Workbook"
	$xWorkbook = $objExcel.Workbooks.Add()
	Write-Verbose "[$Group] Making the 1st worksheet active"
	$xWorksheet = $xWorkbook.ActiveSheet
	$xCells = $xWorksheet.Cells
	Write-Verbose "[$Group] Creating column headers and input other info about the group"
	$xCells.item(1,2) = "Group Name"
	$xCells.item(1,2).font.bold = $True
	$xCells.item(1,3) = $Group
	$xCells.item(2,2) = "Notes"
	$xCells.item(2,2).font.bold = $True
	$xCells.item(2,3) = $GroupObject.info
	$xCells.item(3,1) = "Members"
	$xCells.item(3,1).font.bold = $True
	$xCells.item(3,2) = "Title"
	$xCells.item(3,2).font.bold = $True
	$xCells.item(3,3) = "UserName"
	$xCells.item(3,3).font.bold = $True
	$xCells.item(3,4) = "EmailAddress"
	$xCells.item(3,4).font.bold = $True
	$Row = 4
	Write-Verbose "[$Group] Input members into worksheet"
	ForEach ($Member in $GroupMembers) {
		Write-Verbose "[$Group][$($Member.SAMAccountName)] Processing Member"
		$EmailAddress = (Get-ADUser $($Member.SAMAccountName) -Properties EmailAddress | Select-Object EmailAddress).EmailAddress
		$Title = (Get-ADUser $($Member.SAMAccountName) -Properties Title | Select-Object Title).Title
		$xCells.item($Row,1) = $Member.name
		$xCells.item($Row,2) = $Title
		$xCells.item($Row,3) = $Member.SAMAccountName
		$xCells.item($Row,4) = $EmailAddress
		$Row = $Row + 1
	}
	Write-Verbose "[$Group] Auto sizing the columns"
	$xWorkSheet.columns.item("A:C").EntireColumn.AutoFit() | Out-Null
	Write-Verbose "[$Group] Making the application visible"
	$objExcel.Visible=$True
}