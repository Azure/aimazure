<#
.SYNOPSIS
Invokes the deployment of the Message Bus Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-90-MessageBus-LogicApp.ps1
#>

& $PSScriptRoot\New-MessageBus-LogicApp.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-aff" -resourceName "logic-aimmsgbussvc-dev-aff" -templateFile "$PSScriptRoot\messagebus.logic.json" -templateParameterFile "$PSScriptRoot\messagebus.logic.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-aff" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -workflowFolder "$PSScriptRoot\messagebus.logic.workflows" -deploymentName "messagebus.logicapp.uksouth.aff"
