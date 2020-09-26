<#
.SYNOPSIS
Tears down the Key Vault resource for the routing store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
./Remove-RoutingStore-KeyVault.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -resourceName "kv-aimrstore-dev"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName
)

$resourceExists = az keyvault show --name $resourceName --resource-group $resourceGroupName

if ($resourceExists) {
    Write-Host "Removing the key vault resource: $resourceName"

    az keyvault delete --name $resourceName --resource-group $resourceGroupName

    Write-Host "Removed the key vault resource: $resourceName"
}
else {
    Write-Host "The key vault resource $resourceName does not exist in resource group $resourceGroupName"
}
