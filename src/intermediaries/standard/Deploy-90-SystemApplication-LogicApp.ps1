<#
.SYNOPSIS
Invokes the deployment of the SystemApplication Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-90-SystemApplication-LogicApp.ps1
#>

& $PSScriptRoot\New-SystemApplication-LogicApp.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -resourceName "logic-aimsystemapplication-dev-xxxxx" -templateFile "$PSScriptRoot\systemapplication.logic.json" -templateParameterFile "$PSScriptRoot\systemapplication.logic.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -workflowFolder "$PSScriptRoot\systemapplication.logic.workflows" -deploymentName "systemapplication.logicapp.uksouth.xxxxx"
