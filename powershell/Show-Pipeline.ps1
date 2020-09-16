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
