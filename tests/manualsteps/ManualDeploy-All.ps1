<#
.SYNOPSIS
Invokes the deployment of all manual resources into Azure.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure.

.PARAMETER uniqueDeploymentId
The unique deployment id used in the automated deployment.

.EXAMPLE
.\ManualDeploy-All.ps1 -uniqueDeploymentId 'xxxxxx'
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $uniqueDeploymentId
)

$filePaths = get-childitem $PSScriptRoot\ -Recurse  -Include *.ps1

$templates = @()

$filePaths | ForEach-Object {
    $fileName = Split-Path $_ -leaf

    if ($fileName -match 'Deploy-([0-9]*?)-(?:.*.ps1)' ) {
        $priority = $Matches.1
        $templates += @{FullPath = $_; Name = $name; Priority = $priority }      
    }
}

$templates | Sort-Object { [int]$_.Priority } | ForEach-Object {
    & $_.FullPath -uniqueDeploymentId $uniqueDeploymentId    
}
