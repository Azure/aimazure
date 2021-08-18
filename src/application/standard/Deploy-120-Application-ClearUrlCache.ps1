<#
.SYNOPSIS
Clears the APIM cache for all workflows in this application Logic App

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-120-Application-ClearUrlCache.ps
#>

& $PSScriptRoot\New-Application-ClearUrlCache.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-xxxxx" -resourceName "logic-application-dev-xxxxx" -workflowName "workflow" -apimInstanceName "apim-aimmsgbussvc-dev-xxxxx" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited"
