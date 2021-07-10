<#
.SYNOPSIS
Invokes the teardown of all resources from Azure.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure.

.PARAMETER minDeploymentPriority
The minimum priority number found in the file name to be deployed.

.PARAMETER maxDeploymentPriority
The maximum priority number found in the file name to be deployed.

.EXAMPLE
.\TearDown-All.ps1
.\TearDown-All.ps1 -minDeploymentPriority 10 -maxDeploymentPriority 200
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $false)]
    [int] $minDeploymentPriority = [int32]::MinValue,
    [parameter(Mandatory = $false)]
    [int] $maxDeploymentPriority = [int32]::MaxValue
)

class Template {
    [string]$FileName
    [string]$FullPath
    [int]$Priority

    Template(
        [string]$fileName,
        [string]$fullPath,
        [int]$priority
    ) {
        $this.FileName = $fileName
        $this.FullPath = $fullPath
        $this.Priority = $priority
    }
}

# Read in the resources.
$filePaths = @(
    "$PSScriptRoot\..\src\messagebus\messagebusgroup\TearDown-10-MessageBusGroup.ps1",
    "$PSScriptRoot\..\src\messagebus\artifactstore\TearDown-20-ArtifactStore.ps1",
    "$PSScriptRoot\..\src\application\applicationgroup\TearDown-10-ApplicationGroup.ps1",
    "$PSScriptRoot\..\src\messagebus\artifactstore\TearDown-20-ArtifactStore.ps1",
    "$PSScriptRoot\..\src\application\schemas\TearDown-100-Schema.ps1"    

)

$templates = @()

# Extract the priority and file name from the template full path.
$filePaths | ForEach-Object {
    $fileName = Split-Path $_ -leaf

    if ($fileName -match 'TearDown-([0-9]*?)-(?:.*.ps1)' ) {
        $priority = $Matches.1
        $templates += [Template]::new($fileName, $_, $priority)
    }
}

# Run the scripts in descending order.
# Filter based on the min and max priority.
$templates | Where-Object { $_.Priority -ge $minDeploymentPriority } | Where-Object { $_.Priority -le $maxDeploymentPriority } | Sort-Object { $_.Priority } -Descending | Select-Object -ExpandProperty FullPath -Unique | ForEach-Object {
    & $_
    # The Azure CLI does not currently reset colors there is an issue raised: https://github.com/Azure/azure-cli/issues/13979
    # The following command manually resets colors.
    [Console]::ResetColor()
}