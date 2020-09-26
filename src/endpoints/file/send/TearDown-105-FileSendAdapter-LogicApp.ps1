<#
.SYNOPSIS
Invokes the teardown of the file send adapter.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-105-FileSendAdapter-LogicApp.ps1
#>

& $PSScriptRoot\Remove-FileSendAdapter-LogicApp.ps1 -resourceGroup "rg-aimapp-aim-file-dev-uksouth-xxxxx" -resourceName "logic-aimfilesadapter-sendfile-file-dev-xxxxx"