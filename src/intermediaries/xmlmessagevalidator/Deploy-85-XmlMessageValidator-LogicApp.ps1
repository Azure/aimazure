<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-85-XmlMessageValidator-LogicApp.ps1
#>

& $PSScriptRoot\New-XmlMessageValidator-LogicApp.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth" -templateFile "$PSScriptRoot\xmlmessagevalidator.logicapp.json" -templateParameterFile "$PSScriptRoot\xmlmessagevalidator.logicapp.dev.parameters.json" -keyVaultName "kv-aimrstore-dev-xxxxx" -keyVaultApimSubscriptionSecretName "aim-apim-subscriptionkey-unlimited" -deploymentName "xmlmessagevalidator.logicapp.uksouth.xxxxx"
