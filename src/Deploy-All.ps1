<#
.SYNOPSIS
Invokes the deployment of all resources into Azure.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure.

.PARAMETER minDeploymentPriority
The minimum priority number found in the file name to be deployed.

.PARAMETER maxDeploymentPriority
The maximum priority number found in the file name to be deployed.

.PARAMETER maxRetriesPerScript
The maximum number of retries per script.

.PARAMETER retryPauseInSeconds
The pause in seconds between retries.

.EXAMPLE
.\Deploy-All.ps1
.\Deploy-All.ps1 -minDeploymentPriority 10 -maxDeploymentPriority 200 -maxRetriesPerScript 2 -retryPauseInSeconds 5
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $false)]
    [int] $minDeploymentPriority = [int32]::MinValue,
    [parameter(Mandatory = $false)]
    [int] $maxDeploymentPriority = [int32]::MaxValue,
    [parameter(Mandatory = $false)]
    [int] $maxRetriesPerScript = 2,
    [parameter(Mandatory = $false)]
    [int]$retryPauseInSeconds = 5
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

function New-DeploymentWithRetry {
    <#
    .SYNOPSIS
    Runs the deployment script and retries optionally on failures.

    .PARAMETER scriptFullPath
    The full path to the script for the deployment.
    #>
    Param($scriptFullPath)

    $deploymentComplete = $false
    $retryCount = 0

    while (-not $deploymentComplete) {
        try {
            & $scriptFullPath -ErrorAction Continue    
            $deploymentComplete = $true
        }
        catch {
            [Console]::ResetColor()            
            Write-Error -Exception $_.Exception
            if ($retryCount -gt $maxRetriesPerScript) {
                Write-Host "Exceeded the retry count for script $scriptFullPath"
                $deploymentComplete = $true
            }
            else {
                $retryCount++
                Write-Host "Retrying in $retryPauseInSeconds seconds for script $scriptFullPath"
                Start-Sleep $retryPauseInSeconds                
            }
        }
    }   
}

# Read in the resources.
$filePaths = @(
    "$PSScriptRoot\..\src\messagebus\messagebusgroup\Deploy-10-MessageBusGroup.ps1",
    "$PSScriptRoot\..\src\application\applicationgroup\Deploy-10-ApplicationGroup.ps1",
    "$PSScriptRoot\..\src\messagebus\artifactstore\Deploy-20-ArtifactStore.ps1",
    "$PSScriptRoot\..\src\messagebus\artifactstore\Deploy-20-ArtifactStore.ps1",
    "$PSScriptRoot\..\src\application\schemas\Deploy-100-Schema.ps1"    
)

$templates = @()

# Extract the priority and file name from the template full path.
$filePaths | ForEach-Object {
    $fileName = Split-Path $_ -leaf

    if ($fileName -match 'Deploy-([0-9]*?)-(?:.*.ps1)' ) {
        $priority = $Matches.1        
        $templates += [Template]::new($fileName, $_, $priority)
    }
}

# Run the scripts in ascending order.
# Filter based on the min and max priority.
$templates | Where-Object { $_.Priority -ge $minDeploymentPriority } | Where-Object { $_.Priority -le $maxDeploymentPriority } | Sort-Object { $_.Priority } | Select-Object -ExpandProperty FullPath -Unique | ForEach-Object {
    New-DeploymentWithRetry $_
}