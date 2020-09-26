<#
.SYNOPSIS
Invokes the deployment of the role assignment for the API Management resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-35-MessageBusService-ApiManagement-RoleAsignment.ps1
#>

& $PSScriptRoot\New-MessageBusService-ApiManagement-RoleAssignment.ps1 -subscriptionId "<azure-subs-id>" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -name "apim-aimmsgbussvc-dev" -messageBusResourceGroupName "rg-aimmsgbus-dev-uksouth" -role "Get Logic App Callback Url xxxxx"