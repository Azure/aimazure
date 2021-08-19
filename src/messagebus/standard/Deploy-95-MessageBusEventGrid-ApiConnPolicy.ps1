<#
.SYNOPSIS
Invokes the deployment of the message bus event grid api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-95-MessageBusEventGrid-ApiConnPolicy.ps1
#>

& $PSScriptRoot\New-MessageBusEventGrid-ApiConnPolicy.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-aff" -templateFile "$PSScriptRoot\messagebuseventgrid.apicaccesspolicy.json" -templateParameterFile "$PSScriptRoot\messagebuseventgrid.apicaccesspolicy.dev.parameters.json" -deploymentName "messagebuseg.apicaccesspolicy.uksouth.aff"