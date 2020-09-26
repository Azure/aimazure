<#
.SYNOPSIS
Tears down the App Service plan resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
./Remove-MessageBusService-AppService.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -resourceName "plan-aimmsgbussvc-dev"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName
)

$resourceExists = az appservice plan show --name $resourceName --resource-group $resourceGroupName

if ($resourceExists) {
    Write-Host "Removing the app service resource: $resourceName"

    az appservice plan delete --name $resourceName --resource-group $resourceGroupName --yes

    Write-Host "Removed the app service resource: $resourceName"
}
else {
    Write-Host "The app service resource $resourceName does not exist in resource group $resourceGroupName"
}
