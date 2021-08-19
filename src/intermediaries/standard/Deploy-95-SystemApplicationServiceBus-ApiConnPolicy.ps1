<#
.SYNOPSIS
Invokes the deployment of the system application service bus api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-95-SystemApplicationServiceBus-ApiConnPolicy.ps1
#>

& $PSScriptRoot\New-SystemApplicationServiceBus-ApiConnPolicy.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\systemapplicationservicebus.apicaccesspolicy.json" -templateParameterFile "$PSScriptRoot\systemapplicationservicebus.apicaccesspolicy.dev.parameters.json" -deploymentName "systemapplicationsb.apicaccesspolicy.uksouth.xxxxx"