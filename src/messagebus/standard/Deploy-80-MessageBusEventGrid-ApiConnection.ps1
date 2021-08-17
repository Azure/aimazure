<#
.SYNOPSIS
Invokes the deployment of the message bus event grid api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-80-MessageBusEventGrid-ApiConnection.ps1
#>

& $PSScriptRoot\New-MessageBusEventGrid-ApiConnection.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-aff" -templateFile "$PSScriptRoot\messagebuseventgrid.apiconnection.json" -templateParameterFile "$PSScriptRoot\messagebuseventgrid.apiconnection.dev.parameters.json" -deploymentName "messagebuseventgrid.apiconnection.uksouth.aff"