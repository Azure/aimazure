<#
.SYNOPSIS
Invokes the deployment of a process manager service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-ProcessManagerServiceBus-ApiConnection.ps1
#>

& $PSScriptRoot\New-ProcessManagerServiceBus-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\processmanagerservicebus.apiconnection.json" -templateParameterFile "$PSScriptRoot\processmanagerservicebus.apiconnection.dev.parameters.json" -deploymentName "processmanagerservicebus.apic.uksouth.xxxxx"
