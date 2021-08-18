<#
.SYNOPSIS
Creates the Message Bus Logic App.

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
Name of the folder containing the Logic App Workflows.

.PARAMETER deploymentName
The name used to identify this instance of the deployment.

.EXAMPLE
.\New-MessageBus-LogicApp.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-xxxxx" -resourceName "logic-aimmsgbussvc-dev-xxxxx" -templateFile "$PSScriptRoot\messagebus.logicapp.json" -templateParameterFile "$PSScriptRoot\messagebus.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -workflowFolder "$PSScriptRoot\messagebus.logic.workflows" -deploymentName "messagebus.logicapp.uksouth.xxxxx"
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

Write-Host "Deploying the Message Bus Logic App`r`n Template File: $templateFile`r`n Parameter File: $templateParameterFile`r`n Deployment Name: $deploymentName`r`n"

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters $templateParameterFile --parameters "apimSubscriptionKey=$apimSubscriptionKey" --name $deploymentName 

Write-Host "Deployment complete"

Write-Host "Creating a ZIP file from the workflow folder"
# create the zip
$zipFile = "$workflowFolder.zip"
if(Test-path $zipFile) {Remove-item $zipFile}
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($workflowFolder, $zipFile)

Write-Host "Zip File creation complete"

Write-Host "Uploading the message bus logic app zip package $zipFile"

if (!(Test-Path $zipFile)) {
    throw "Zip file $zipFile doesn't exist, unable to upload"
}

az logicapp deployment source config-zip --resource-group $resourceGroupName --name $resourceName --src "$zipFile"

Write-Host "Upload complete"

