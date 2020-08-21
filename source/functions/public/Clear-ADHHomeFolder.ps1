Function Clear-ADHHomeFolder {
	[CmdletBinding(SupportsShouldProcess)]
	Param(
		[Parameter(Mandatory=$True,Position=1)]
		[string[]]$User,

		[Parameter(Mandatory=$False)]
		[string]$Server = $(Get-ADHServerValue),

		[Parameter(Mandatory=$False)]
		[switch]$DeleteHomeFolder
	)

	ForEach ($Obj in $User) {
		If ($DeleteHomeFolder) {
			$Params = @{
				'Identity' = $Obj
				'Properties' = 'HomeDirectory'
			}
			If ($Server -ne "") {$Params.Add('Server',$Server)}
			$HomeFolder = Get-ADUser @Params | Select-Object -ExpandProperty HomeDirectory
		}
		Try {
			$Params = @{
				'Identity' = $Obj
				'Properties' = 'HomeDirectory','HomeDrive'
			}
			$Params2 = @{
				'Clear' = 'HomeDirectory','HomeDrive'
			}
			If ($Server -ne "") {
				$Params.Add('Server',$Server)
				$Params2.Add('Server',$Server)}
			Get-ADUser @Params | Set-ADUser @Params2
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