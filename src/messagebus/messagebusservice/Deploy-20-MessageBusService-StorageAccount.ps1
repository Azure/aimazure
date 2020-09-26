<#
.SYNOPSIS
Invokes the deployment of a Storage Account resource for use by Azure Function apps.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-20-MessageBusService-StorageAccount.ps1
#>

$params = Get-Content -Path $PSScriptRoot\messagebusservice.st.dev.psparameters.json -Raw | ConvertFrom-Json
& $PSScriptRoot\New-MessageBusService-StorageAccount.ps1 -resourceGroupName $params.resourceGroupName -name $params.name -location $params.location -kind $params.kind -sku $params.sku -tags $params.tags
