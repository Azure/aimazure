<#
.SYNOPSIS
Invokes the deployment of a fto receive adapters service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-FtpReceiveAdapterServiceBus-ApiConnection.ps1
#>

& $PSScriptRoot\New-FtpReceiveAdapterServiceBus-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\ftpreceiveadapterservicebus.apiconnection.json" -templateParameterFile "$PSScriptRoot\ftpreceiveadapterservicebus.apiconnection.dev.parameters.json" -deploymentName "ftpreceiveadaptersb.apiconnection.uksouth.xxxxx"