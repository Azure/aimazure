<#
.SYNOPSIS
Creates a Storage Account resource for use by Azure Function apps.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER name
Name of the storage account that will be created.

.PARAMETER location
Location of the storage account that will be created.

.PARAMETER sku
The sku of the storage account, such as, Standard_GRS or Premium_LRS.  For a full list see:
https://docs.microsoft.com/en-us/cli/azure/storage/account?view=azure-cli-latest#az-storage-account-create

.PARAMETER tags
The tags to apply to the storage account.

.EXAMPLE
./New-MessageBusService-StorageAccount.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -name "staimmsgbussvcdev001"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $name,
    [parameter(Mandatory = $true)]
    [string] $location,
    [parameter(Mandatory = $false)]
    [string] $kind = "StorageV2",
    [parameter(Mandatory = $false)]
    [string] $sku = "Standard_LRS",
    [parameter(Mandatory = $false)]
    [string[]] $tags = ""
)

Write-Host "Deploying the storage account: $name"

az storage account create --name $name --resource-group $resourceGroupName --location $location --kind $kind --sku $sku --tags $tags
if (!$?)
{
    # A storage account is a global resource, so this may cause a failure if it already exists in
    # another subscription.
    throw "Deployment failed, aborting"
}

Write-Host "Deployment complete"