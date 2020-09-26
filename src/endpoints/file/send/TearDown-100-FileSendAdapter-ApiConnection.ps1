<#
.SYNOPSIS
Invokes the teardown of the file send adapters api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-100-FileSendAdapter-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-FileSendAdapter-ApiConnection.ps1 -resourceGroup "rg-aimapp-aim-file-dev-uksouth-xxxxx" -resourceName "apic-aimfilesconnector-sendfile-file-dev-xxxxx"