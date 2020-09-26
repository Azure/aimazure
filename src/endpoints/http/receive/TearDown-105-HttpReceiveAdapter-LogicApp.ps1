<#
.SYNOPSIS
Invokes the teardown of the http receive adapter logic app.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-105-HttpReceiveAdapter-LogicApp.ps1
#>

& $PSScriptRoot\Remove-HttpReceiveAdapter-LogicApp.ps1 -resourceGroup "rg-aimapp-aim-httpjsonorch-dev-uksouth-xxxxx" -resourceName "logic-aimhttpradapter-purchaseorderhttpjsonreceive-dev-xxxxx"