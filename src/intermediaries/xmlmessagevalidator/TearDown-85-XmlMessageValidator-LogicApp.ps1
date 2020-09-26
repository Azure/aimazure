<#
.SYNOPSIS
Invokes the teardown of the Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-85-XmlMessageValidator-LogicApp.ps1
#>

& $PSScriptRoot\Remove-XmlMessageValidator-LogicApp.ps1 -resourceGroup "rg-aimapp-systemapplication-dev-uksouth" -workflowName "logic-aimxmlmessagevalidator-dev-xxxxx"