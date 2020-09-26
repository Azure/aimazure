<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-85-MessageResponseHandler-LogicApp.ps1
#>

& $PSScriptRoot\New-MessageResponseHandler-LogicApp.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\messageresponsehandler.logicapp.json" -templateParameterFile "$PSScriptRoot\messageresponsehandler.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "messageresponsehandler.logicapp.uksouth.xxxxx"
