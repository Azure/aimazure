<#
.SYNOPSIS
Clears the Url Cache for a given Workflow in this Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the Logic App is located.

.PARAMETER resourceName
Name of the Logic App.

.PARAMETER workflowName
Name of the Workflow.

.PARAMETER apimInstanceName
Name of the APIM instance used to clear the cache.

.PARAMETER keyVaultName
The name of the key vault store.

.PARAMETER keyVaultApimSubscriptionSecretName
The name of secret in key vault which stores the apim subscription.

.EXAMPLE
.\New-Application-ClearUrlCache.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-xxxxx" -resourceName "logic-application-dev-xxxxx" -workflowName "workflowname" -apimInstanceName "apim-aimmsgbussvc-dev-xxxxx" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName,
	[parameter(Mandatory = $true)]
    [string] $workflowName,
    [parameter(Mandatory = $true)]    
    [string] $apimInstanceName,
    [parameter(Mandatory = $true)]
    [string] $keyVaultName,
    [parameter(Mandatory = $true)]
    [string] $keyVaultApimSubscriptionSecretName
)

Write-Host "Getting the subscription from Key Vault for APIM"

$apimSubscriptionKey = az keyvault secret show --name $keyVaultApimSubscriptionSecretName --vault-name $keyVaultName --query value
if (!$apimSubscriptionKey) {
    throw "Unable to get a secret from the vault $keyVaultName with the name $keyVaultApimSubscriptionSecretName"
}

$apimBaseUrl = "https://$apimInstanceName.azure-api.net/aimroutingmanager/standardlogicappcallbackurl/$resourceGroupName/$resourceName"
Write-Host "Using base url: $apimBaseUrl"

Write-Host "Clearing cache for Workflow"

Write-Host "$workflowName"
az rest --method get --url "$apimBaseUrl/$workflowName?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "Cache Clearing complete"