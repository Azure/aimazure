<#
.SYNOPSIS
Invokes the deployment of an ftp receive adapter.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-FtpReceiveAdapter-LogicApp.ps1
#>

& $PSScriptRoot\New-FtpReceiveAdapter-LogicApp.ps1 -resourceGroupName "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\ftpreceiveadapter.logicapp.json" -templateParameterFile "$PSScriptRoot\ftpreceiveadapter.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "ftpreceiveadapter.logicapp.uksouth.xxxxx"