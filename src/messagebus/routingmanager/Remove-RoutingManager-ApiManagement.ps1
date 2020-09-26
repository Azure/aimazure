<#
.SYNOPSIS
Tears down the API resource in API Management for the routing manager.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER serviceName
The name of the API Management service to find the resource.

.PARAMETER apiName
The name of the API resource in API Management to remove.

.EXAMPLE
./Remove-RoutingManager-ApiManagement.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -serviceName "apim-aimmsgbussvc-dev" -apiName "aimroutingmanager"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $serviceName,
    [parameter(Mandatory = $true)]
    [string] $apiName
)

$resourceExists = az resource show --resource-group $resourceGroupName  --name $apiName --namespace "Microsoft.ApiManagement" --parent "service/$serviceName" --resource-type "apis"

if ($resourceExists) {
    Write-Host "Removing the API resource for service $serviceName : $apiName"

    az resource delete --resource-group $resourceGroupName --name $apiName --namespace "Microsoft.ApiManagement" --parent "service/$serviceName" --resource-type "apis"

    Write-Host "Removed the API resource for service $serviceName : $apiName"
}
else {
    Write-Host "The API resource $apiName for service $serviceName does not exist in resource group $resourceGroupName"
}
