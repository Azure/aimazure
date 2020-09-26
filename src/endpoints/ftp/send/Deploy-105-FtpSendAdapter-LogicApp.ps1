<#
.SYNOPSIS
Invokes the deployment of an ftp adapter.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
Deploy-105-FtpSendAdapter-LogicApp.ps1
#>

& $PSScriptRoot\New-FtpSendAdapter-LogicApp.ps1 -resourceGroupName "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\ftpsendadapter.logicapp.json" -templateParameterFile "$PSScriptRoot\ftpsendadapter.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "ftpsendadapter.logicapp.xxxxx"