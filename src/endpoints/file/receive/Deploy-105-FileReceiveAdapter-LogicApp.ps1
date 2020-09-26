<#
.SYNOPSIS
Invokes the deployment of a file receive adapter.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-FileReceiveAdapter-LogicApp.ps1
#>

& $PSScriptRoot\New-FileReceiveAdapter-LogicApp.ps1 -resourceGroupName "rg-aimapp-aim-file-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\filereceiveadapter.logicapp.json" -templateParameterFile "$PSScriptRoot\filereceiveadapter.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "filereceiveadapter.logicapp.uksouth.dev"