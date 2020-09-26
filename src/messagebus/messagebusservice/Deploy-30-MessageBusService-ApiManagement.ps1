<#
.SYNOPSIS
Invokes the deployment of an API Management resource for use by various AIM components.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-30-MessageBusService-ApiManagement.ps1
#>

$params = Get-Content -Path $PSScriptRoot\messagebusservice.apim.dev.psparameters.json -Raw | ConvertFrom-Json
& $PSScriptRoot\New-MessageBusService-ApiManagement.ps1 -subscriptionId $params.subscriptionId -resourceGroupName $params.resourceGroupName -name $params.name -location $params.location -appConfigName $params.appConfigName -keyVaultName $params.keyVaultName -publisherName $params.publisherName -publisherEmail $params.publisherEmail -sku $params.sku -skuCapacity $params.skuCapacity -tags $params.tags
