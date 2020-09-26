<#
.SYNOPSIS
Invokes the deployment of a http receive adapter.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-105-HttpReceiveAdapter-LogicApp.ps1
#>

& $PSScriptRoot\New-HttpReceiveAdapter-LogicApp.ps1 -resourceGroupName "rg-aimapp-aim-httpjsonorch-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\httpreceiveadapter.logicapp.json" -templateParameterFile "$PSScriptRoot\httpreceiveadapter.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "httpreceiveadapter.logicapp.uksouth.xxxxx"