<#
.SYNOPSIS
Invokes the teardown of ftp receive adapter logic app.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-105-FtpReceiveAdapter-LogicApp.ps1
#>

& $PSScriptRoot\Remove-FtpReceiveAdapter-LogicApp.ps1 -resourceGroup "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -resourceName "logic-aimftpradapter-aim-ftppassthru-receivelocation-dev-xxxxx"