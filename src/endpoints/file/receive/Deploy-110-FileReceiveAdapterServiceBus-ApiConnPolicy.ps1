<#
.SYNOPSIS
Invokes the deployment of the ftp receive service bus api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-FtpReceiveAdapterServiceBus-ApiConnPolicy.ps1
#>

& $PSScriptRoot\New-FtpReceiveAdapterServiceBus-ApiConnPolicy.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-aff" -templateFile "$PSScriptRoot\ftpreceiveadapterservicebus.apiconnpolicy.json" -templateParameterFile "$PSScriptRoot\ftpreceiveadapterservicebus.apiconnpolicy.dev.parameters.json" -deploymentName "ftpreceiveadapterservicebus.apicaccesspolicy.uksouth.aff"