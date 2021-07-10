<#
.SYNOPSIS
Invokes the deployment of a sftp receive adapter service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-SftpReceiveAdapterServiceBus-ApiConnection.ps1
#>

& $PSScriptRoot\New-SftpReceiveAdapterServiceBus-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-sftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\sftpreceiveadapterservicebus.apiconnection.json" -templateParameterFile "$PSScriptRoot\sftpreceiveadapterservicebus.apiconnection.dev.parameters.json" -deploymentName "sftpreceiveadaptersb.apiconnection.uksouth.xxxxx"