Param(
    [Parameter(mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Path
)

Add-Type -AssemblyName System.Drawing
Describe 'PSSA Standard Rules' {
	#$Scripts = Get-ChildItem -Path $Path -File -Recurse | Where-Object {$_.Extension -eq '.psm1'}
	$Scripts = Get-ChildItem $Path -Include *.ps1, *.psm1, *.psd1 -Recurse
	ForEach ($Script in $Scripts) {
		Context "$($Script.Name)" {
			$Analysis = Invoke-ScriptAnalyzer -Path $($Script.FullName) -ExcludeRule 'PSAvoidUsingPlainTextForPassword'
			$ScriptAnalyzerRules = Get-ScriptAnalyzerRule | Where-Object RuleName -ne 'PSAvoidUsingPlainTextForPassword'
			ForEach ($Rule in $ScriptAnalyzerRules) {
				It "Should pass $Rule" {
					If ($Analysis.RuleName -contains $Rule) {
						$Analysis |	Where-Object RuleName -EQ $Rule -OutVariable Failures | Out-Default
						$Failures.Count | Should Be 0
					}
				}
			}
		}
	}
}