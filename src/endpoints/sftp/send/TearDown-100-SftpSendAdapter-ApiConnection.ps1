<#
.SYNOPSIS
Invokes the teardown of sftp connector.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-100-SftpSendAdapter-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-SftpSendAdapter-ApiConnection.ps1 -resourceGroup "rg-aimapp-aim-sftppassthru-dev-uksouth-xxxxx" -resourceName "apic-aimsftpsconnector-aim-sftppassthru-sendport-dev-xxxxx"