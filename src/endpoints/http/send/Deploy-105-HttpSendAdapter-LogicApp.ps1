<#
.SYNOPSIS
Invokes the deployment of a http send adapter.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-105-HttpSendAdapter-LogicApp.ps1
#>

& $PSScriptRoot\New-HttpSendAdapter-LogicApp.ps1 -resourceGroupName "rg-aimapp-aim-httpjsonorch-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\httpsendadapter.logicapp.json" -templateParameterFile "$PSScriptRoot\httpsendadapter.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "httpsendadapter.logicapp.uksouth.xxxxx"