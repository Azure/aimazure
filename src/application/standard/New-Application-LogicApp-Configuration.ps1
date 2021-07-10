<#
.SYNOPSIS
Creates the Application Logic App Configuration.
This script will merge the individual workflow config files into single files,
prior to the workflows app being uploaded to the Logic App in Azure.
Note that if you want to open this Logic App project in VS Code,
you need to run this script first.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER workflowFolder
Location of the folder containing the Logic App Workflows.

.EXAMPLE
.\New-Application-LogicApp-Configuration.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-xxxxx" -resourceName "logic-application-dev-xxxxx" -workflowFolder "$PSScriptRoot\application.logic.workflows"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName,	
	[parameter(Mandatory = $true)]
    [string] $workflowFolder
)

Write-Host "Merging Parameter Files"

# We're using PowerShell Hashtables to merge the Json files.
# We're not using Newtonsoft's Json.NET JObject.Merge() option here
# as we can't guarantee the version of PowerShell being used has access to Json.NET.
$mergedParameters = [ordered]@{}

Get-ChildItem "$workflowFolder\*.parameters.json" -Recurse | 
Foreach-Object {
    $parameterFile = Get-Content $_.FullName -Raw | ConvertFrom-Json -AsHashTable
	
	# Remove any duplicate property names - have to do this or the merge will fail
	# as we'll be generating invalid Json
	foreach ($jsonPropertyName in $parameterFile.Keys) {
        if ($mergedParameters.Contains($jsonPropertyName)) {
            $mergedParameters.Remove($jsonPropertyName);
        }
    }
	
	# Union the two hashtables together
	$mergedParameters = $mergedParameters + $parameterFile;
	
	# Delete this file
	Remove-Item -Path $_.FullName
}

# Output a new merged parameters file
ConvertTo-Json $mergedParameters -Depth 10 | Set-Content "$workflowFolder\parameters.json"

Write-Host "Parameter File Merging Complete"

Write-Host "Merging Local Parameter Files"

# We're using PowerShell Hashtables to merge the Json files.
# We're not using Newtonsoft's Json.NET JObject.Merge() option here
# as we can't guarantee the version of PowerShell being used has access to Json.NET.
$mergedLocalParameters = [ordered]@{}

Get-ChildItem "$workflowFolder\*.parameters.local.json" -Recurse | 
Foreach-Object {
    $localParameterFile = Get-Content $_.FullName -Raw | ConvertFrom-Json -AsHashTable
	
	# Remove any duplicate property names - have to do this or the merge will fail
	# as we'll be generating invalid Json
	foreach ($jsonPropertyName in $localParameterFile.Keys) {
        if ($mergedLocalParameters.Contains($jsonPropertyName)) {
            $mergedLocalParameters.Remove($jsonPropertyName);
        }
    }
	
	# Union the two hashtables together
	$mergedLocalParameters = $mergedLocalParameters + $localParameterFile;
	
	# Delete this file
	Remove-Item -Path $_.FullName
}

# Output a new merged local parameters file
ConvertTo-Json $mergedLocalParameters -Depth 10 | Set-Content "$workflowFolder\parameters.local.json"

Write-Host "Local Parameter File Merging Complete"

Write-Host "Merging Connection Files"

# We're using PowerShell Hashtables to merge the Json files.
# We're not using Newtonsoft's Json.NET JObject.Merge() option here
# as we can't guarantee the version of PowerShell being used has access to Json.NET.
$serviceProviderConnections = [ordered]@{}
$managedApiConnections = [ordered]@{}

Get-ChildItem "$PSScriptRoot\*.connections.json" -Recurse | 
Foreach-Object {
    $connectionsFile = Get-Content $_.FullName -Raw | ConvertFrom-Json -AsHashTable
	
	if ($connectionsFile.Contains("serviceProviderConnections"))
	{
		$tempServiceProviderConnections = $connectionsFile["serviceProviderConnections"]
		foreach ($serviceProviderConnectionKey in $tempServiceProviderConnections.Keys) {
			if (-Not $serviceProviderConnections.Contains($serviceProviderConnectionKey))
			{
				$serviceProviderConnections[$serviceProviderConnectionKey] = $tempServiceProviderConnections[$serviceProviderConnectionKey]
			}
		}
	}
	
	if ($connectionsFile.Contains("managedApiConnections"))
	{
		$tempManagedApiConnections = $connectionsFile["managedApiConnections"]
		foreach ($managedApiConnectionKey in $tempManagedApiConnections.Keys) {
			if (-Not $managedApiConnections.Contains($managedApiConnectionKey))
			{
				$managedApiConnections[$managedApiConnectionKey] = $tempManagedApiConnections[$managedApiConnectionKey]
			}
		}
	}
	
	# Delete this file
	Remove-Item -Path $_.FullName
}

$connections = [ordered]@{}
$connections["serviceProviderConnections"] = $serviceProviderConnections
$connections["managedApiConnections"] = $managedApiConnections

ConvertTo-Json $connections -Depth 10 | Set-Content "$workflowFolder\connections.json"

Write-Host "Connection File Merging Complete"

Write-Host "Merging Local AppSetting Files"

# We're using PowerShell Hashtables to merge the Json files.
# We're not using Newtonsoft's Json.NET JObject.Merge() option here
# as we can't guarantee the version of PowerShell being used has access to Json.NET.
$mergedLocalAppSettings = [ordered]@{}

Get-ChildItem "$workflowFolder\*.appsettings.local.json" -Recurse | 
Foreach-Object {
    $localAppSettingsFile = Get-Content $_.FullName -Raw | ConvertFrom-Json -AsHashTable
	
	# Remove any duplicate property names - have to do this or the merge will fail
	# as we'll be generating invalid Json
	foreach ($jsonPropertyName in $localAppSettingsFile.Keys) {
        if ($mergedLocalAppSettings.Contains($jsonPropertyName)) {
            $mergedLocalAppSettings.Remove($jsonPropertyName);
        }
    }
	
	# Union the two hashtables together
	$mergedLocalAppSettings = $mergedLocalAppSettings + $localAppSettingsFile;
	
	# Delete this file
	Remove-Item -Path $_.FullName
}

# Create Local App Settings format
$localAppSettings = [ordered]@{}
$localAppSettings["IsEncrypted"] = $false
$localAppSettings["Values"] = $mergedLocalAppSettings

# Output a new merged local appsettings file
ConvertTo-Json $localAppSettings -Depth 10 | Set-Content "$workflowFolder\appsettings.local.json"

Write-Host "Local AppSetting File Merging Complete"