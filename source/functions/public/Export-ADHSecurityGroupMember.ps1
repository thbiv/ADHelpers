Function Export-ADHSecurityGroupMember {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$True,Position=1)]
		[string]$Group,

		[Parameter(Mandatory=$False)]
		[string]$Server = $(Get-ADHServerValue)
	)
	Write-Verbose "[$Group] Getting group members"
	$Params1 = @{
		'Identity' = $Group
	}
	If ($Server -ne "") {{$Params1.Add('Server',$Server)}}
	$GroupMembers = Get-ADGroupMember @Params1
	Write-Verbose "[$Group] Geting properties"
	$Params2 = @{
		'Identity' = $Group
		'Properties' = '*'
	}
	If ($Server -ne "") {{$Params2.Add('Server',$Server)}}
	$GroupObject = Get-ADGroup @Params2
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
		$Params3 = @{
			'Identity' = $($Member.SAMAccountName)
			'Properties' = 'EmailAddress','Title'
		}
		If ($Server -ne "") {{$Params3.Add('Server',$Server)}}
		$UserData = Get-ADUser @Params3 | Select-Object EmailAddress,Title
		$xCells.item($Row,1) = $Member.name
		$xCells.item($Row,2) = $UserData.Title
		$xCells.item($Row,3) = $Member.SAMAccountName
		$xCells.item($Row,4) = $UserData.EmailAddress
		$Row++
	}
	Write-Verbose "[$Group] Auto sizing the columns"
	$xWorkSheet.columns.item("A:C").EntireColumn.AutoFit() | Out-Null
	Write-Verbose "[$Group] Making the application visible"
	$objExcel.Visible=$True
}