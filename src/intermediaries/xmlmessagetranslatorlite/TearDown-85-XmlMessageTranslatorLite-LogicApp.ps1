<#
.SYNOPSIS
Invokes the teardown of the Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-85-XmlMessageTranslatorLite-LogicApp.ps1
#>

& $PSScriptRoot\Remove-XmlMessageTranslatorLite-LogicApp.ps1 -resourceGroup "rg-aimapp-systemapplication-dev-uksouth" -workflowName "logic-aimxmlmessagetranslatorlite-dev-xxxxx"