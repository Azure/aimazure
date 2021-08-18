<#
.SYNOPSIS
Clears the APIM cache of Workflow URLs for the System Application Logic App

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-120-SystemApplication-ClearUrlCache.ps
#>

& $PSScriptRoot\New-SystemApplication-ClearUrlCache.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-xxxxx" -resourceName "logic-application-dev-xxxxx" -apimInstanceName "apim-aimmsgbussvc-dev-xxxxx" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited"
