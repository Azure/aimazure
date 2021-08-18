<#
.SYNOPSIS
Invokes the teardown of the system application logic app.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-90-SystemApplication-LogicApp.ps1
#>

& $PSScriptRoot\Remove-SystemApplication-LogicApp.ps1 -resourceGroup "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -logicAppName "logic-aimsystemapplication-dev-xxxxx"