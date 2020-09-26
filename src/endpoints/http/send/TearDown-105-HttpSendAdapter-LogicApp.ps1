<#
.SYNOPSIS
Invokes the teardown of the http send adapter logic app.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-105-HttpSendAdapter-LogicApp.ps1
#>

& $PSScriptRoot\Remove-HttpSendAdapter-LogicApp.ps1 -resourceGroup "rg-aimapp-aim-httpjsonorch-dev-uksouth-xxxxx" -resourceName "logic-aimhttpsadapter-purchaseorderhttpjsonsend-dev-xxxxx"