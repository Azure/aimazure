<#
.SYNOPSIS
Invokes the deployment of a file send adapters api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-FileSendAdapter-ApiConnection.ps1
#>

& $PSScriptRoot\New-FileSendAdapter-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-file-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\filesystemsendadapter.apiconnection.json" -templateParameterFile "$PSScriptRoot\filesystemsendadapter.apiconnection.dev.parameters.json" -deploymentName "filesystemsendadapter.apiconnection.uksouth.xxxxx"