<#
.SYNOPSIS
Clears the Url Cache for all Workflows in this Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the Logic App is located.

.PARAMETER resourceName
Name of the Logic App.

.PARAMETER apimInstanceName
Name of the APIM instance used to clear the cache.

.PARAMETER keyVaultName
The name of the key vault store.

.PARAMETER keyVaultApimSubscriptionSecretName
The name of secret in key vault which stores the apim subscription.

.EXAMPLE
.\New-Application-ClearUrlCache.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -resourceName "logic-aimsystemapplication-dev-xxxxx" -apimInstanceName "apim-aimmsgbussvc-dev-xxxxx" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName,	
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

Write-Host "Clearing cache for each Workflow"

Write-Host "contentdemoter"
az rest --method get --url "$apimBaseUrl/contentdemoter?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "contentpromoter"
az rest --method get --url "$apimBaseUrl/contentpromoter?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "jsondecoder"
az rest --method get --url "$apimBaseUrl/jsondecoder?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "jsonencoder"
az rest --method get --url "$apimBaseUrl/jsonencoder?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "messageconstructor"
az rest --method get --url "$apimBaseUrl/messageconstructor?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "messageresponsehandler"
az rest --method get --url "$apimBaseUrl/messageresponsehandler?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "messagesuspendprocessor"
az rest --method get --url "$apimBaseUrl/messagesuspendprocessor?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "routingsliprouter"
az rest --method get --url "$apimBaseUrl/routingsliprouter?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "topicpublisher"
az rest --method get --url "$apimBaseUrl/topicpublisher?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "xmlenvelopewrapper"
az rest --method get --url "$apimBaseUrl/xmlenvelopewrapper?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "xmlmessageprocessor"
az rest --method get --url "$apimBaseUrl/xmlmessageprocessor?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "xmlmessagevalidator"
az rest --method get --url "$apimBaseUrl/xmlmessagevalidator?clearCache=true" --headers "Ocp-Apim-Subscription-Key=$apimSubscriptionKey" --skip-authorization-header --output none

Write-Host "Cache Clearing complete"