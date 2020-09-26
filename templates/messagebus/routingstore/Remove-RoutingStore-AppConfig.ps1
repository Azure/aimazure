<#
.SYNOPSIS
Tears down the App Config resource for the routing store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
./Remove-RoutingStore-AppConfig.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -resourceName "appcfg-aimrstore-dev"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName
)

$resourceExists = az appconfig show --name $resourceName --resource-group $resourceGroupName

if ($resourceExists) {
    Write-Host "Removing the app config resource: $resourceName"

    az appconfig delete --name $resourceName --resource-group $resourceGroupName --yes

    Write-Host "Removed the app config resource: $resourceName"
}
else {
    Write-Host "The app config resource $resourceName does not exist in resource group $resourceGroupName"
}
