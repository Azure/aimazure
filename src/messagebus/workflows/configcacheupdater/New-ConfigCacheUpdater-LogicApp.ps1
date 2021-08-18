<#
.SYNOPSIS
Creates a Logic App.

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

.PARAMETER deploymentName
The name used to identify this instance of the deployment.

.EXAMPLE
./New-ConfigCacheUpdater-LogicApp.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -templateFile ".\configcacheupdater.logicapp.json" -templateParameterFile ".\configcacheupdater.logicapp.dev.parameters" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -startupState "Enabled" -deploymentName "configcacheupdater.logicapp.uksouth.xxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]    
    [string] $templateFile,
    [parameter(Mandatory = $true)]
    [string] $templateParameterFile,
    [string] $keyVaultName,
    [parameter(Mandatory = $true)]
    [string] $keyVaultApimSubscriptionSecretName,
	[parameter(Mandatory = $true)]
    [string] $startupState,
    [parameter(Mandatory = $true)]
    [string] $deploymentName
)

Write-Host "Getting the subscription from Key Vault for APIM"

$apimSubscriptionKey = az keyvault secret show --name $keyVaultApimSubscriptionSecretName --vault-name $keyVaultName --query value
if (!$apimSubscriptionKey) {
    throw "Unable to get a secret from the vault $keyVaultName with the name $keyVaultApimSubscriptionSecretName"
}

Write-Host "Deploying the config cache updater Logic App`r`n Template File: $templateFile`r`n Parameter File: $templateParameterFile`r`n Deployment Name: $deploymentName`r`n"

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters "$templateParameterFile" --parameters "apimSubscriptionKey=$apimSubscriptionKey" --parameters "logicAppStartupState=$startupState" --name $deploymentName

Write-Host "Deployment complete"
