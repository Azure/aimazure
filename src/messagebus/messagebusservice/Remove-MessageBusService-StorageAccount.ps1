<#
.SYNOPSIS
Tears down the Storage Account resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroup
The name of the resource group containing the resources to remove.

.PARAMETER resourceName
The name of the resource to remove.

.EXAMPLE
./Remove-MessageBusService-StorageAccount.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -resourceName "staimmsgbussvcdev001"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName
)

$resourceExists = az storage account show --name $resourceName --resource-group $resourceGroupName

if ($resourceExists) {
    Write-Host "Removing the storage account resource: $resourceName"

    az storage account delete --name $resourceName --resource-group $resourceGroupName --yes

    Write-Host "Removed the storage account resource: $resourceName"
}
else {
    Write-Host "The storage account resource $resourceName does not exist in resource group $resourceGroupName"
}
