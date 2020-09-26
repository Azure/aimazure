<#
.SYNOPSIS
Invokes the teardown of ftp connector.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-100-FtpSendAdapter-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-FtpSendAdapter-ApiConnection.ps1 -resourceGroup "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -resourceName "apic-aimftpsconnector-aim-ftppassthru-sendport-dev-xxxxx"