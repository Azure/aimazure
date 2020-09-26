<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-85-XmlEnvelopeWrapper-LogicApp.ps1
#>

& $PSScriptRoot\New-XmlEnvelopeWrapper-LogicApp.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth" -templateFile "$PSScriptRoot\xmlenvelopewrapper.logicapp.json" -templateParameterFile "$PSScriptRoot\xmlenvelopewrapper.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "xmlenvelopewrapper.logicapp.uksouth.xxxxx"
