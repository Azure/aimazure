<#
.SYNOPSIS
Invokes the teardown of process manager service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-100-ProcessManagerServiceBus-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-ProcessManagerServiceBus-ApiConnection.ps1 -resourceGroup "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -resourceName "apic-aimsbconnector-processmanager-dev-xxxxx"