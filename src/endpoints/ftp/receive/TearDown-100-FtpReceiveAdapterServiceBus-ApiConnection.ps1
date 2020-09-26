<#
.SYNOPSIS
Invokes the teardown of a ftp receive adapters service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-100-FtpReceiveAdapterServiceBus-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-FtpReceiveAdapterServiceBus-ApiConnection.ps1 -resourceGroup "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -resourceName "apic-topicpublisherconnector-ftpreceiveadapter-dev-xxxxx"