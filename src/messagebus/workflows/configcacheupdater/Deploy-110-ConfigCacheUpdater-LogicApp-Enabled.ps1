<#
.SYNOPSIS
Invokes the deployment of a Logic App in an Enabled state.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-110-ConfigCacheUpdater-LogicApp-Enabled.ps1
#>

& $PSScriptRoot\New-ConfigCacheUpdater-LogicApp.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\configcacheupdater.logicapp.json" -templateParameterFile "$PSScriptRoot\configcacheupdater.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -startupState "Enabled" -deploymentName "configcacheupdater.logicapp.uksouth.xxxxx"
