<#
.SYNOPSIS
Invokes the teardown of a file receive adapters file system api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-100-FileReceiveAdapterFileystem-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-FileReceiveAdapterFileSystem-ApiConnection.ps1 -resourceGroup "rg-aimapp-aim-file-dev-uksouth-xxxxx" -resourceName "apic-topicpublisherconnector-filereceiveadapter-dev-xxxxx"