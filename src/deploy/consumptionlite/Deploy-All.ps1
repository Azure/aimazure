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

.PARAMETER runUnattended
If 1, then the user is not prompted for input and no verification checks are made, any other value, the user is prompted for input and verification checks are made before the scripts are executed.

.EXAMPLE
.\Deploy-All.ps1
.\Deploy-All.ps1 -minDeploymentPriority 10 -maxDeploymentPriority 200 -maxRetriesPerScript 2 -retryPauseInSeconds 5 -runUnattended 1
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
    [int]$retryPauseInSeconds = 5,
	[parameter(Mandatory = $false)]
    [int]$runUnattended = 0
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

# Script version 0.2
$version = '0.2'

# Get current text foreground colour for the current shell.
# There is a bug in the Azure CLI which means that on error, it changes the default colour for the PowerShell Host.
# We attempt to get the current colour and use it for non-error Write-Host commands.
$defaultForegroundColour = (get-host).ui.rawui.ForegroundColor
if ( $defaultForegroundColour -eq -1 )
{
    $defaultForegroundColour = White
}

$haveErrors = 'false'
$haveWarnings = 'false'
if ($runUnattended -ne 1)
{
	Write-Host ""
	Write-Host "Welcome to the Microsoft BTS Migrator tool Deployment Script v$version, Logic Apps Consumption edition." -ForegroundColor $defaultForegroundColour
	Write-Host ""
	Write-Host "This script will attempt to deploy only application-related migrated resources, using the Logic Apps Consumption offering." -ForegroundColor $defaultForegroundColour
	Write-Host ""
	Write-Host "NOTE: This is the LITE version of the deployment: it assumes that you have already run the full installation," -ForegroundColor Yellow
	Write-Host "and that this installation is using the same unique deployment id (xxxxx)." -ForegroundColor Yellow
	Write-Host "If neither of these conditions are true, then this installation will fail." -ForegroundColor Yellow
	Write-Host ""
	Write-Host "Before deploying resources, this script will check the following:" -ForegroundColor $defaultForegroundColour
	Write-Host "   1) Is the Azure CLI installed?" -ForegroundColor $defaultForegroundColour
	Write-Host "   2) Can you login to the Azure CLI?" -ForegroundColor $defaultForegroundColour
	Write-Host "   3) Have you selected a subscription?" -ForegroundColor $defaultForegroundColour
	Write-Host ""
	Write-Host "After completing these steps, the tool will check if you wish to proceed with deployment." -ForegroundColor $defaultForegroundColour
	Write-Host ""
	Read-Host "Press any key to continue..."
	# Step 1: Is the Azure CLI installed
	Write-Host "Step 1: Is the Azure CLI installed?" -ForegroundColor $defaultForegroundColour
	try
	{
		$null = Invoke-Expression -Command "az version" -ErrorVariable cliError -ErrorAction SilentlyContinue
	}
	catch {}

	if ($cliError[0])
	{
		Write-Host "Step 1: Failure: The Azure CLI is not installed." -ForegroundColor Red
		Write-Host "You will need to install it by following the instructions here:" -ForegroundColor $defaultForegroundColour
		Write-Host "https://docs.microsoft.com/en-us/cli/azure/install-azure-cli" -ForegroundColor $defaultForegroundColour
		Write-Host ""
		Write-Host "This script will now terminate, as the rest of the script relies on the Azure CLI being installed." -ForegroundColor $defaultForegroundColour
		Write-Host "Please try running this script again after you have installed the CLI." -ForegroundColor $defaultForegroundColour
		Write-Host ""
		Write-Host "Completed checking pre-requisites for the BTS Migrator tool." -ForegroundColor $defaultForegroundColour
		Write-Host ""
		return
	}
	else 
	{
		$cliVersion = az version --query '\"azure-cli\"' --output tsv
		Write-Host "Step 1: Success: v$cliVersion of the Azure CLI is installed." -ForegroundColor Green
		Write-Host ""
	}

	# Step 2: Can you login to the Azure CLI
	Write-Host "Step 2: Can you login to the Azure CLI?" -ForegroundColor $defaultForegroundColour
	Write-Host "Starting Login Process." -ForegroundColor $defaultForegroundColour
	Write-Host "Note: A browser window should open, prompting you for the account to use with the Azure CLI." -ForegroundColor $defaultForegroundColour
	Write-Host "If this does not happen, manually browse to https://aka.ms/devicelogin and enter the code shown in this window." -ForegroundColor $defaultForegroundColour
	Write-Host "If you are unable to perform this step, follow the instructions here:" -ForegroundColor $defaultForegroundColour
	Write-Host "https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli" -ForegroundColor $defaultForegroundColour

	$loginResult = az login --only-show-errors
	if (!$loginResult)
	{
		Write-Host "Step 2: Failure: Unable to login to the Azure CLI." -ForegroundColor Red
		Write-Host "This script will now terminate, as the rest of the script relies on having logged in." -ForegroundColor $defaultForegroundColour
		Write-Host "Please try running this script again after you have fixed the issue." -ForegroundColor $defaultForegroundColour
		Write-Host ""
		Write-Host "Completed checking pre-requisites for the BTS Migrator tool." -ForegroundColor $defaultForegroundColour
		Write-Host ""
		return
	}
	else
	{
		$accountName = az account show --query "user.name" --output tsv
		Write-Host "Step 2: Success: Login to the Azure CLI succeeded." -ForegroundColor Green
		Write-Host "Logged in as: $accountName." -ForegroundColor $defaultForegroundColour
		Write-Host ""
	}

	# Step 3: Can you select a default subscription
	Write-Host "Step 3: Can you select a default subscription?" -ForegroundColor $defaultForegroundColour
	Write-Host "Note: You may have trouble selecting a subscription if Multi-Factor Authentication is enabled for that subscription." -ForegroundColor $defaultForegroundColour
	Write-Host "If that is the case, you may need to edit this PowerShell script, and add --tenant <tenant id> to the az login command." -ForegroundColor $defaultForegroundColour
	Write-Host ""
	$subscriptionsCount = az account list --query "length([?contains(user.name, '$accountName')])" --output tsv
	$subscriptionsTable = az account list --query "[?contains(user.name, '$accountName')].{Name:name, SubscriptionId:id, IsDefault:isDefault, State:state, TenantId:tenantId}" --output table
	if ( $subscriptionsCount -gt 1 )
	{
		Write-Host "You have access to more than one subscription." -ForegroundColor $defaultForegroundColour
		Write-Host "Please choose the subscription you wish to use" -ForegroundColor $defaultForegroundColour
		Write-Host "(or press ENTER to use the default subscription)" -ForegroundColor $defaultForegroundColour
		Write-Host ""
		$subscriptionsTable | Format-Table | Out-String | Write-Host
		$subscriptionId = Read-Host "Enter the SubscriptionId or name (with quotes if contains spaces) of the subscription to use (or ENTER for default)"
		if ( $subscriptionId -ne '' )
		{
			Write-Host "Setting subscription to use..."
			az account set --subscription $subscriptionId
			$currentSubscription = az account show --query "name" --output tsv
			Write-Host "Using subscription: $currentSubscription." -ForegroundColor $defaultForegroundColour
		}
		else
		{
			$currentSubscription = az account show --query "name" --output tsv
			$subscriptionId = az account show --query "id" --output tsv
			Write-Host "Using default subscription: $currentSubscription." -ForegroundColor $defaultForegroundColour
		}
	}
	else
	{
		$currentSubscription = az account show --query "name" --output tsv
		Write-Host "Using subscription: $currentSubscription." -ForegroundColor $defaultForegroundColour
	}

	Write-Host "Step 3: Success: Selected a subscription." -ForegroundColor Green
	Write-Host ""

	# Test if we were successful
	if ( $haveErrors -eq 'true' )
	{
		Write-Host "The deployment scripts will probably fail with errors (see errors and warnings above)." -ForegroundColor Red
		Write-Host ""
		exit
	}
	elseif ( $haveWarnings -eq 'true' )
	{
		Write-Host "The deployment scripts will probably succeed (see warnings above)." -ForegroundColor Yellow
		Write-Host ""
	}
	else
	{
		Write-Host "Excellent news, the deployment scripts should run with no errors." -ForegroundColor Green
		Write-Host ""
	}

	$continue = Read-Host "Would you like to continue with deployment? (Y or N)"
	if ( $continue -ne "Y" )
	{
		Write-Host "Exiting deployment script at user request." -ForegroundColor Red
		Write-Host ""
		exit
	}

	Write-Host "Starting deployment of Azure Resources to subscription '$currentSubscription' ($subscriptionId)" -ForegroundColor $defaultForegroundColour
}
else
{
	Write-Host "Starting deployment of Azure Resources to current subscription, in unattended mode" -ForegroundColor $defaultForegroundColour
}
Write-Host ""

# If we're in UI mode, assign a stopwatch so we can output the elapsed runtime
if ($runUnattended -ne 1)
{
	$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
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

# If we're in UI mode, output the elapsed time
if ($runUnattended -ne 1)
{
	$stopwatch.Stop()
	Write-Host ("Deployment elapsed time: {0:d2}:{1:d2}:{2:d2} (hh:mm:ss)" -f $stopwatch.Elapsed.Hours, $stopwatch.Elapsed.Minutes, $stopwatch.Elapsed.Seconds) -ForegroundColor $defaultForegroundColour
}