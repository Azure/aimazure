<#
.SYNOPSIS
Invokes the deployment of an API in API Management for the configuration manager.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-40-ConfigManager-ApiManagement.ps1
#>

& $PSScriptRoot\New-ConfigManager-ApiManagement.ps1 -subscriptionId "<azure-subs-id>" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -apimServiceName "apim-aimmsgbussvc-dev" -apiName "aimconfigurationmanager" -templateFile "$PSScriptRoot\configmanager.apim.json" -templateParameterFile "$PSScriptRoot\configmanager.apim.dev.parameters.json" -deploymentName "configmanager.apim.uksouth.xxxxx"
