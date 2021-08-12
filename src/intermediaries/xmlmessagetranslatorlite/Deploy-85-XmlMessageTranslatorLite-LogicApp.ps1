<#
.SYNOPSIS
Invokes the deployment of a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-85-XmlMessageTranslatorLite-LogicApp.ps1
#>

& $PSScriptRoot\New-XmlMessageTranslatorLite-LogicApp.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth" -templateFile "$PSScriptRoot\xmlmessagetranslatorlite.logicapp.json" -templateParameterFile "$PSScriptRoot\xmlmessagetranslatorlite.logicapp.dev.parameters.json" -deploymentName "xmlmessagetranslatorlite.logicapp.uksouth.xxxxx"
