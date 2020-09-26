<#
.SYNOPSIS
Invokes the deployment of an ftp receive adapters ftp ftp api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-100-FtpReceiveAdapterFtp-ApiConnection.ps1
#>

& $PSScriptRoot\New-FtpReceiveAdapterFtp-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\ftpreceiveadapterftp.apiconnection.json" -templateParameterFile "$PSScriptRoot\ftpreceiveadpdapterftp.apiconnection.dev.parameters.json" -deploymentName "ftpreceiveadapterftp.apiconnection.uksouth.xxxxx"