<#
.SYNOPSIS
Invokes the teardown of ftp adapter.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-105-FtpSendAdapter-LogicApp.ps1
#>

& $PSScriptRoot\Remove-FtpSendAdapter-LogicApp.ps1 -resourceGroup "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -resourceName "logic-aimftpsadapter-aim-ftppassthru-sendport-dev-xxxxx"