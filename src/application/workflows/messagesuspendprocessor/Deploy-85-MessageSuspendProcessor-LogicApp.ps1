<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-85-MessageSuspendProcessor-LogicApp.ps1
#>

& $PSScriptRoot\New-MessageSuspendProcessor-LogicApp.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\messagesuspendprocessor.logicapp.json" -templateParameterFile "$PSScriptRoot\messagesuspendprocessor.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "messagesuspendprocessor.logicapp.uksouth.xxxxx"