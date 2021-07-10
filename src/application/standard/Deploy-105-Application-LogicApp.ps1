<#
.SYNOPSIS
Invokes the deployment of the Application Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-105-Application-LogicApp.ps1
#>

& $PSScriptRoot\New-Application-LogicApp.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-xxxxx" -resourceName "logic-application-dev-xxxxx" -templateFile "$PSScriptRoot\application.logic.json" -templateParameterFile "$PSScriptRoot\application.logic.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -workflowFolder "$PSScriptRoot\application.logic.workflows" -deploymentName "application.logicapp.uksouth.xxxxx"
