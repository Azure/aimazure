<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-90-ContentDemoter-LogicApp.ps1
#>

& $PSScriptRoot\New-ContentDemoter-LogicApp.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\contentdemoter.logicapp.json" -templateParameterFile "$PSScriptRoot\contentdemoter.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "contentdemoter.logicapp.uksouth.xxxxx"
