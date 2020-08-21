Function Reset-ADHUserPassword {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory=$True,Position=1)][string]$UserName,
		[Parameter(Mandatory=$False)][switch]$ForceChangePasswordAtLogon
	)
	$AD_DomainControllers = Get-ADDomainController -filter {isReadOnly -eq $False} | Select-Object -ExpandProperty HostName
    $NewPass = Read-Host -AsSecureString "Enter user's New Password [Leave Blank to EXIT]"
    If (!($NewPass -eq "")) {
        $NewPass2 = Read-Host -AsSecureString "Re-Enter user's New Password"
        If ($NewPass2 -eq $NewPass) {
	        ForEach ($Server in $AD_DomainControllers) {
                Write-Verbose "[$UserName][$Server] Resetting Password"
                If ($PSCmdlet.ShouldProcess("Set Password for $UserName on $Server")) {
                    Set-ADAccountPassword -Identity $UserName -Server $Server -NewPassword $NewPass -Reset
                }
                If ($ForceChangePasswordAtLogon) {
                    Write-Verbose "[$UserName][$Server] Forcing password to change at next logon"
                    If ($PSCmdlet.ShouldProcess("Force Change Password for $UserName on $Server")) {
                        Set-ADUser -Identity $UserName -Server $Server -ChangePasswordAtLogon
                    }
                }
	        }
        }
        Else {
            Write-Warning "[$UserName] Passwords did not match"
        }
    }
}
Set-Alias -Name rpw -Value Reset-ADUserPassword -Description 'Reset AD users password'