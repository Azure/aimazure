<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-90-JsonDecoder-LogicApp.ps1
#>

& $PSScriptRoot\New-JsonDecoder-LogicApp.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\jsondecoder.logicapp.json" -templateParameterFile "$PSScriptRoot\jsondecoder.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "jsondecoder.logicapp.uksouth.xxxxx"
