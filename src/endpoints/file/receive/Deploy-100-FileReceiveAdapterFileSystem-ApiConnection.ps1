<#
.SYNOPSIS
Invokes the deployment of a file receive adapters file system api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-FileReceiveAdapterFileSystem-ApiConnection.ps1
#>

& $PSScriptRoot\New-FileReceiveAdapterFileSystem-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-file-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\filereceiveadapterfilesystem.apiconnection.json" -templateParameterFile "$PSScriptRoot\filereceiveadapterfilesystem.apiconnection.dev.parameters.json" -deploymentName "filereceiveadapterfile.apiconnection.uksouth.xxxxx"