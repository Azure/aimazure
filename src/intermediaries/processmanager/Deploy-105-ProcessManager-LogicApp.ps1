<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-105-ProcessManager-LogicApp.ps1
#>

& $PSScriptRoot\New-ProcessManager-LogicApp.ps1 -resourceGroupName "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\processmanager.logicapp.json" -templateParameterFile "$PSScriptRoot\processmanager.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "processmanager.logicapp.uksouth.xxxxx"
