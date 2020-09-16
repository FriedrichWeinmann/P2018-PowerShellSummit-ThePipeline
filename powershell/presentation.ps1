# failsafe
break

<#
    About me:
  Twitter: @FredWeinmann
  Github: FriedrichWeinmann
  Slack (PowerShell): Fred
  Slack (SQL Community): Fred
  Slack (Summit): Fred

  Projects: dbatools, dbachecks, psframework, psutil, psmoduledevelopment
  Website: http://psframework.org | https://allthingspowershell.blogspot.de
  Repository: https://github.com/FriedrichWeinmann/P2018-PowerShellSummit-ThePipeline
#>
function Show-Pipeline
{
<#
	.SYNOPSIS
		Demo function that shows how the pipeline processes objects.
	
	.DESCRIPTION
		Demo function that shows how the pipeline processes objects.
	
	.PARAMETER InputObject
		The object to pass through.
	
	.PARAMETER Name
		Name of the execution. Used when reporting the workflow to screen.
	
	.PARAMETER Stagger
		Stagger all input objects to be passed along when the next input is received.
	
	.PARAMETER Fail
		When to throw an exception.
	
	.PARAMETER Wait
        How many seconds to wait when processing an item.
        
    .PARAMETER ShowEnd
        Shows when the process block is ended.
	
	.EXAMPLE
		PS C:\> Show-Pipeline
#>
	[CmdletBinding()]
	Param (
		[Parameter(ValueFromPipeline = $true)]
		$InputObject,
		
		[string]
		$Name,
		
		[switch]
		$Stagger,
		
		[ValidateSet('Begin','Process','End')]
		[string]
		$Fail,
		
		[int]
        $Wait,
        
        [switch]
        $ShowEnd,

        [ValidateScript( { $false } )]
        [bool]
        $BadInput
	)
	
	begin
	{
        #region Begin
        $color = @{
            first = 'DarkGreen'
            second = 'red'
            third = 'blue'
            default = 'black'
        }

		Write-PSFMessage -Level Host -Message "[<c='DarkGreen'>Begin</c>][<c='$($color[$name])'>$Name</c>] Killing puppies and processing $InputObject"
		if ($Fail -eq "Begin") { throw "[Begin][$Name] Failing as planned!" }
        $cache = $null
        #endregion Begin
	}
	
	process
	{
		foreach ($item in $InputObject)
		{
            #region Process
            $waiting = ""
            if ($Wait) { $waiting = " waiting for $wait seconds" }
			Write-PSFMessage -Level Host -Message "[<c='yellow'>Process</c>][<c='$($color[$name])'>$Name</c>] Killing puppies and processing $item$($waiting)"
			if ($Fail -eq "Process") { throw "[Process][$Name] Failing as planned!" }
			if ($Wait -gt 0) { Start-Sleep -Seconds $Wait }
			
			if ($Stagger)
			{
				if ($cache) { $cache }
				$cache = $item
			}
            else { $item }
            
            if ($ShowEnd) { Write-PSFMessage -Level Host -Message "[<c='yellow'>Process</c>][<c='$($color[$name])'>$Name</c>] Killing puppies and finishing processing $item$($waiting)" }
            #endregion Process
		}
	}
	
	end
	{
        #region End
		Write-PSFMessage -Level Host -Message "[<c='red'>End</c>][<c='$($color[$name])'>$Name</c>] Killing puppies and processing $InputObject"
		if ($Fail -eq "End") { throw "[End][$Name] Failing as planned!" }
        if ($Stagger) { $cache }
        #endregion End
	}
}

function Show-NoPipeline
{
    <#
        .SYNOPSIS
            Demo function that does not support pipeline.

        .DESCRIPTION
            Demo function that does not support pipeline.
            It does not use begin/process/end, it just sends objects into output at some point.

        .PARAMETER Fail
            Using this parameter will terminate the function with an exception.
    #>
    [CmdletBinding()]
    param (
        [switch]
        $Fail
    )

    #region Plain Code
    if ($Fail) { throw "Failing as ordered to" }

    foreach ($item in ("a","b","c"))
    {
        Write-PSFMessage -Level Host -Message "[<c='darkblue'>NoPipe(?)</c>] Killing puppies and sending $item"
        $item
    }
    #endregion Plain Code
}

$in = "a","b","c"
# The order of things
$in | Show-Pipeline -Name "first" | Show-Pipeline -Name "second" | Show-Pipeline -Name "third"

# Where things end
$in | Show-Pipeline -Name "first" -ShowEnd | Show-Pipeline -Name "second" -ShowEnd | Show-Pipeline -Name "third" -ShowEnd

# Taking a nap
$in | Show-Pipeline -Name "first" | Show-Pipeline -Name "second" -Wait 3 | Show-Pipeline -Name "third"

# In the end
$in | Show-Pipeline -Name "first" | Show-Pipeline -Name "second" -Wait 1 -Stagger | Show-Pipeline -Name "third"

# Killing pipelines
$in | Show-Pipeline -Name "first" | Show-Pipeline -Name "second" -Fail "Begin" | Show-Pipeline -Name "third"

# More wanton slaughter
$in | Show-Pipeline -Name "first" | Show-Pipeline -Name "second" -Fail "Process" | Show-Pipeline -Name "third"

# An act of mass pipelinicide
$in | Show-Pipeline -Name "first" | Show-Pipeline -Name "second" -Fail "End" | Show-Pipeline -Name "third"

# Bad Apple
$in | Show-Pipeline -Name "first" | Show-Pipeline -Name "second" | Show-Pipeline -Name "third" -BadInput $true

# Working as designed?
Show-NoPipeline | Show-Pipeline -Name "first"

# Not really
Show-NoPipeline -Fail | Show-Pipeline -Name "first"
