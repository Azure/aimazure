<#
.SYNOPSIS
Invokes the deployment of the event grid subscribe api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-80-EventGridSubscribe-ApiConnection.ps1
#>

& $PSScriptRoot\New-EventGridSubscribe-ApiConnection.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-aff" -templateFile "$PSScriptRoot\eventgridsubscribe.apiconnection.json" -templateParameterFile "$PSScriptRoot\eventgridsubscribe.apiconnection.dev.parameters.json" -deploymentName "eventgridsubscribe.apiconnection.uksouth.aff"