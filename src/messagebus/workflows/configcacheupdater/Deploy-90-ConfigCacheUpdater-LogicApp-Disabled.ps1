<#
.SYNOPSIS
Invokes the deployment of a Logic App in a Disabled state.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-90-ConfigCacheUpdater-LogicApp-Disabled.ps1
#>

& $PSScriptRoot\New-ConfigCacheUpdater-LogicApp.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\configcacheupdater.logicapp.json" -templateParameterFile "$PSScriptRoot\configcacheupdater.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -startupState "Disabled" -deploymentName "configcacheupdater.logicapp.uksouth.xxxxx"
