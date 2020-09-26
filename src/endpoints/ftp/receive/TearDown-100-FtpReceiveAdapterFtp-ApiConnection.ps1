<#
.SYNOPSIS
Invokes the teardown of ftp receive adapters ftp api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-100-FtpReceiveAdapterFtp-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-FtpReceiveAdapterFtp-ApiConnection.ps1 -resourceGroup "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -resourceName "apic-aimftprconnector-aim-ftppassthru-receivelocation-dev-xxxxx"