<#
.SYNOPSIS
Invokes the teardown of sftp receive adapter api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-100-SftpReceiveAdapterSftp-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-SftpReceiveAdapterSftp-ApiConnection.ps1 -resourceGroup "rg-aimapp-aim-sftppassthru-dev-uksouth-xxxxx" -resourceName "apic-aimsftprconnector-aim-sftppassthru-receivelocation-dev-xxxxx"