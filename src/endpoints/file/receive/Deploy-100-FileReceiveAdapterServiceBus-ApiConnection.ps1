<#
.SYNOPSIS
Invokes the deployment of a file receive adapters service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-FileReceiveAdapterServiceBus-ApiConnection.ps1
#>

& $PSScriptRoot\New-FileReceiveAdapterServiceBus-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-file-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\filereceiveadapterservicebus.apiconnection.json" -templateParameterFile "$PSScriptRoot\filereceiveadapterservicebus.apiconnection.dev.parameters.json" -deploymentName "filereceiveadaptersb.apiconnection.uksouth.xxxxx"