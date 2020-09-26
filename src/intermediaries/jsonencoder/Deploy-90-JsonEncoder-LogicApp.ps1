<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-90-JsonEncoder-LogicApp.ps1
#>

& $PSScriptRoot\New-JsonEncoder-LogicApp.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\jsonencoder.logicapp.json" -templateParameterFile "$PSScriptRoot\jsonencoder.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "jsonencoder.logicapp.uksouth.xxxxx"
