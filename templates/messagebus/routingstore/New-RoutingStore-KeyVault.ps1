<#
.SYNOPSIS
Creates a Key Vault resource for the routing store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER name
Name of the Key Vault that will be created.

.PARAMETER location
Location where the resource will be created.

.PARAMETER sku
The sku level for the Key Vault resource.

.PARAMETER tags
The tags to apply to the Key Vault resource.

.EXAMPLE
./New-RoutingStore-KeyVault.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -name "kv-aimrstore-dev" -location "UK South" -sku "Standard"
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
    [string] $sku = "Standard",
    [parameter(Mandatory = $false)]
    [string[]] $tags = ""
)

Write-Host "Deploying the routing store Key Vault $name"

az keyvault create --name $name --resource-group $resourceGroupName --location $location --sku $sku --no-self-perms false --enable-soft-delete false --enabled-for-template-deployment true --tags $tags

Write-Host "Deployment complete"