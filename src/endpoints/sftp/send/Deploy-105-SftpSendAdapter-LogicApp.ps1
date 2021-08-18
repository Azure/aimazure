<#
.SYNOPSIS
Invokes the deployment of an sftp adapter.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
Deploy-105-SftpSendAdapter-LogicApp.ps1
#>

& $PSScriptRoot\New-SftpSendAdapter-LogicApp.ps1 -resourceGroupName "rg-aimapp-aim-sftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\sftpsendadapter.logicapp.json" -templateParameterFile "$PSScriptRoot\sftpsendadapter.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "sftpsendadapter.logicapp.xxxxx"