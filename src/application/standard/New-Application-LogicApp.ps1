<#
.SYNOPSIS
Creates the Application Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER templateFile
Path to the ARM template that needs to be deployed.

.PARAMETER templateParameterFile
Path to the ARM template parameter file that contains the parameter values related to the template file.

.PARAMETER keyVaultName
The name of the key vault store.

.PARAMETER keyVaultApimSubscriptionSecretName
The name of secret in key vault which stores the apim subscription.

.PARAMETER workflowFolder
Location of the folder containing the Logic App Workflows.

.PARAMETER deploymentName
The name used to identify this instance of the deployment.

.EXAMPLE
.\New-Application-LogicApp.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-xxxxx" -resourceName "logic-application-dev-xxxxx" -templateFile "$PSScriptRoot\application.logic.json" -templateParameterFile "$PSScriptRoot\application.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -workflowFolder "$PSScriptRoot\application.logic.workflows" -deploymentName "application.logicapp.uksouth.xxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName,	
    [parameter(Mandatory = $true)]    
    [string] $templateFile,
    [parameter(Mandatory = $true)]
    [string] $templateParameterFile,
    [parameter(Mandatory = $true)]
    [string] $keyVaultName,
    [parameter(Mandatory = $true)]
    [string] $keyVaultApimSubscriptionSecretName,
	[parameter(Mandatory = $true)]
    [string] $workflowFolder,
    [parameter(Mandatory = $true)]
    [string] $deploymentName
)

Write-Host "Getting the subscription from Key Vault for APIM"

$apimSubscriptionKey = az keyvault secret show --name $keyVaultApimSubscriptionSecretName --vault-name $keyVaultName --query value
if (!$apimSubscriptionKey) {
    throw "Unable to get a secret from the vault $keyVaultName with the name $keyVaultApimSubscriptionSecretName"
}

Write-Host "Merging AppSetting Files"

# We're using PowerShell Arrays to merge the Json AppSettings files.
# We're not using Newtonsoft's Json.NET JObject.Merge() option here
# as we can't guarantee the version of PowerShell being used has access to Json.NET.
$mergedAppSettings = @()

Get-ChildItem "$workflowFolder\*.appsettings.json" -Recurse | 
Foreach-Object {
    $appSettingsFile = Get-Content $_.FullName -Raw | ConvertFrom-Json -AsHashtable
	
	# Union the two arrays together
	$mergedAppSettings += $appSettingsFile;
	
	# Delete this file
	Remove-Item -Path $_.FullName
}

$templatePath = Split-Path -Path $templateFile
$templateFileName = Split-Path -Path $templateFile -Leaf
$baseTemplateFile = "$templatePath\base.$templateFileName"

# Load in the original template, and add in the updated AppSettings
if (Test-Path -Path $baseTemplateFile -PathType Leaf) {
	$applicationTemplate = Get-Content $baseTemplateFile -Raw | ConvertFrom-Json
	
	# Look for the web site resource
	foreach ($resource in $applicationTemplate.resources) {
			if ($resource.type -eq "Microsoft.Web/sites") {
				$resource.properties.siteConfig.appSettings += $mergedAppSettings
			}
	}

	# Write out a new template
	ConvertTo-Json $applicationTemplate -Depth 10 | Set-Content $templateFile
	
	# Delete the base template file
	Remove-Item -Path $baseTemplateFile
}

Write-Host "Finished AppSetting File Merge"

Write-Host "Deploying the Application Logic App`r`n Template File: $templateFile`r`n Parameter File: $templateParameterFile`r`n Deployment Name: $deploymentName`r`n"

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters $templateParameterFile --parameters "apimSubscriptionKey=$apimSubscriptionKey" --name $deploymentName 

Write-Host "Deployment complete"