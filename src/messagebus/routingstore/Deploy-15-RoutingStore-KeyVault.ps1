<#
.SYNOPSIS
Invokes the deployment of a Key Vault resource for the routing store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-20-RoutingStore-KeyVault.ps1
#>

$params = Get-Content -Path $PSScriptRoot\routingstore.kv.dev.psparameters.json -Raw | ConvertFrom-Json
& $PSScriptRoot\New-RoutingStore-KeyVault.ps1 -resourceGroupName $params.resourceGroupName -name $params.name -location $params.location -sku $params.sku -tags $params.tags
