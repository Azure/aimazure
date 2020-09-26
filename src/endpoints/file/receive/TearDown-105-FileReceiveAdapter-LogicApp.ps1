<#
.SYNOPSIS
Invokes the teardown of a file receive adapter logic app.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-105-FileReceiveAdapter-LogicApp.ps1
#>

& $PSScriptRoot\Remove-FileReceiveAdapter-LogicApp.ps1 -resourceGroup "rg-aimapp-aim-file-dev-uksouth-xxxxx" -resourceName "logic-aimfileradapter-rcvfile-file-dev-xxxxx"