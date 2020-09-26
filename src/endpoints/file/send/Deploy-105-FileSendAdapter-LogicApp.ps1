<#
.SYNOPSIS
Invokes the deployment of a file send adapter.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-105-FileSendAdapter-LogicApp.ps1
#>

& $PSScriptRoot\New-FileSendAdapter-LogicApp.ps1 -resourceGroupName "rg-aimapp-aim-file-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\filesendadapter.logicapp.json" -templateParameterFile "$PSScriptRoot\filesendadapter.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "filesendadapter.logicapp.dev.xxxxx"