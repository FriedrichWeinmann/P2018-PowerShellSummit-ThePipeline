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