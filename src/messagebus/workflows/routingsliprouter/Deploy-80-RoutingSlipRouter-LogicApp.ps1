<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-80-RoutingSlipRouter-LogicApp.ps1
#>

& $PSScriptRoot\New-RoutingSlipRouter-LogicApp.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -templateFile "$PSScriptRoot\routingsliprouter.logicapp.json" -templateParameterFile "$PSScriptRoot\routingsliprouter.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "routingsliprouter.logicapp.uksouth.xxxxx"
