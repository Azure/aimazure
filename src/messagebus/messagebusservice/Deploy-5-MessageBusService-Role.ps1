<#
.SYNOPSIS
Invokes the deployment of a custom Role resource for use by API Management service.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-5-MessageBusService-Role.ps1
#>

& $PSScriptRoot\New-MessageBusService-Role.ps1 -subscriptionId "<azure-subs-id>" -role "Get Logic App Callback Url xxxxx"
