<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-90-ContentPromoter-LogicApp.ps1
#>

& $PSScriptRoot\New-ContentPromoter-LogicApp.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\contentpromoter.logicapp.json" -templateParameterFile "$PSScriptRoot\contentpromoter.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "contentpromoter.logicapp.uksouth.xxxxx"
