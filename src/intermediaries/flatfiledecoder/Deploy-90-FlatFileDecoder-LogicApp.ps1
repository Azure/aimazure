<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-90-FlatFileDecoder-LogicApp.ps1
#>

& $PSScriptRoot\New-FlatFileDecoder-LogicApp.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\flatfiledecoder.logicapp.json" -templateParameterFile "$PSScriptRoot\flatfiledecoder.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "flatfiledecoder.logicapp.uksouth.xxxxx"
