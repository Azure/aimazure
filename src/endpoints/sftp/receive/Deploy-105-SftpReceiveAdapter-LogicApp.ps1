<#
.SYNOPSIS
Invokes the deployment of an sftp receive adapter.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-SftpReceiveAdapter-LogicApp.ps1
#>

& $PSScriptRoot\New-SftpReceiveAdapter-LogicApp.ps1 -resourceGroupName "rg-aimapp-aim-sftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\sftpreceiveadapter.logicapp.json" -templateParameterFile "$PSScriptRoot\sftpreceiveadapter.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "sftpreceiveadapter.logicapp.uksouth.xxxxx"