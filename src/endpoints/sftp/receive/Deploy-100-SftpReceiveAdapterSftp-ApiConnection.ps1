<#
.SYNOPSIS
Invokes the deployment of an sftp receive adapter api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-SftpReceiveAdapterSftp-ApiConnection.ps1
#>

& $PSScriptRoot\New-SftpReceiveAdapterSftp-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-sftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\sftpreceiveadaptersftp.apiconnection.json" -templateParameterFile "$PSScriptRoot\sftpreceiveadpdaptersftp.apiconnection.dev.parameters.json" -deploymentName "sftpreceiveadaptersftp.apiconnection.uksouth.xxxxx"