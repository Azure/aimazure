<#
.SYNOPSIS
Invokes the teardown of sftp adapter.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-105-SftpSendAdapter-LogicApp.ps1
#>

& $PSScriptRoot\Remove-SftpSendAdapter-LogicApp.ps1 -resourceGroup "rg-aimapp-aim-sftppassthru-dev-uksouth-xxxxx" -resourceName "logic-aimsftpsadapter-aim-sftppassthru-sendport-dev-xxxxx"