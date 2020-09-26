<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-85-XmlMessageTranslator-LogicApp.ps1
#>

& $PSScriptRoot\New-XmlMessageTranslator-LogicApp.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth" -templateFile "$PSScriptRoot\xmlmessagetranslator.logicapp.json" -templateParameterFile "$PSScriptRoot\xmlmessagetranslator.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "xmlmessagetranslator.logicapp.uksouth.xxxxx"
