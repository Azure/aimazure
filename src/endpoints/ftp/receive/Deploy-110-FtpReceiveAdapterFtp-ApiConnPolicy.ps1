<#
.SYNOPSIS
Invokes the deployment of the ftp receive api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-FtpReceiveAdapterFtp-ApiConnPolicy.ps1
#>

& $PSScriptRoot\New-FtpReceiveAdapterFtp-ApiConnPolicy.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-aff" -templateFile "$PSScriptRoot\ftpreceiveadapterftp.apiconnpolicy.json" -templateParameterFile "$PSScriptRoot\ftpreceiveadapterftp.apiconnpolicy.dev.parameters.json" -deploymentName "ftpreceiveadapterftp.apicaccesspolicy.uksouth.aff"