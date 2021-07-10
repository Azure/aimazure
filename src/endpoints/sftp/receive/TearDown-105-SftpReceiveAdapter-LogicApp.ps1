<#
.SYNOPSIS
Invokes the teardown of sftp receive adapter logic app.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-105-SftpReceiveAdapter-LogicApp.ps1
#>

& $PSScriptRoot\Remove-SftpReceiveAdapter-LogicApp.ps1 -resourceGroup "rg-aimapp-aim-sftppassthru-dev-uksouth-xxxxx" -resourceName "logic-aimsftpradapter-aim-sftppassthru-receivelocation-dev-xxxxx"