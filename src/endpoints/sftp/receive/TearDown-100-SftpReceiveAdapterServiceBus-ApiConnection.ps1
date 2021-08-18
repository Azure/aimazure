<#
.SYNOPSIS
Invokes the teardown of a sftp receive adapter service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-100-SftpReceiveAdapterServiceBus-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-SftpReceiveAdapterServiceBus-ApiConnection.ps1 -resourceGroup "rg-aimapp-aim-sftppassthru-dev-uksouth-xxxxx" -resourceName "apic-topicpublisherconnector-sftpreceiveadapter-dev-xxxxx"