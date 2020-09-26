<#
.SYNOPSIS
Invokes the deployment of an API in API Management for the messaging manager.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-60-MessagingManager-ApiManagement.ps1
#>

& $PSScriptRoot\New-MessagingManager-ApiManagement.ps1 -subscriptionId "<azure-subs-id>" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -apimServiceName "apim-aimmsgbussvc-dev" -apiName "aimmessagingmanager" -templateFile "$PSScriptRoot\messagingmanager.apim.json" -templateParameterFile "$PSScriptRoot\messagingmanager.apim.dev.parameters.json" -deploymentName "messagingmanager.apim.uksouth.xxxxx"
