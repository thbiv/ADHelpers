#region Import Private Functions
if (Test-Path "$PSScriptRoot\Functions\Private") {
  $FunctionList = Get-ChildItem -Path "$PSScriptRoot\Functions\Private" -Include '*.ps1'
  foreach ($File in $FunctionList) {
      . $File.FullName
      Write-Information -MessageData ('Importing private function file: {0}' -f $File.FullName) -InformationAction Continue
  }
}
#endregion

#region Import Public Functions
if (Test-Path "$PSScriptRoot\Functions\Public") {
  $FunctionList = Get-ChildItem -Path "$PSScriptRoot\Functions\Public"
  foreach ($File in $FunctionList) {
      . $File.FullName
      Write-Information -MessageData ('Importing public function file: {0}' -f $File.FullName) -InformationAction Continue
  }
}
#endregion