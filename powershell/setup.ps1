Set-Content -Path $profile.CurrentUserCurrentHost -Value @'
$presentationRoot = "D:\Code\Github\P2018-PowerShellSummit-ThePipeline"

$temp = Get-PSFConfigValue -FullName psutil.path.temp
$null = New-Item -Path $temp -Name demo -ItemType Directory -Force -ErrorAction Ignore
$demo = Get-Item "$temp\demo"
$null = New-PSDrive -PSProvider FileSystem -Name demo -Root $demo.FullName -ErrorAction Ignore
Set-Location demo:
function prompt 
{
    "" + $ExecutionContext.SessionState.Path.CurrentLocation + "> "
}

. "$presentationRoot\powershell\Show-Pipeline.ps1"
. "$presentationRoot\powershell\Show-NoPipeline.ps1"
'@
$presentationRoot = "D:\Code\Github\P2018-PowerShellSummit-ThePipeline"

$temp = Get-PSFConfigValue -FullName psutil.path.temp
$null = New-Item -Path $temp -Name demo -ItemType Directory -Force -ErrorAction Ignore
$demo = Get-Item "$temp\demo"
$null = New-PSDrive -PSProvider FileSystem -Name demo -Root $demo.FullName -ErrorAction Ignore
Set-Location demo:
function prompt 
{
    "" + $ExecutionContext.SessionState.Path.CurrentLocation + "> "
}

. "$presentationRoot\powershell\Show-Pipeline.ps1"
. "$presentationRoot\powershell\Show-NoPipeline.ps1"