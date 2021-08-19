<#
.SYNOPSIS
Invokes the deployment of the ftp receive api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-FtpReceiveAdapterFtp-ApiConnectionAccessPolicy.ps1
#>

& $PSScriptRoot\New-FtpReceiveAdapterFtp-ApiConnectionAccessPolicy.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-aff" -templateFile "$PSScriptRoot\ftpreceiveadapterftp.apiconnectionaccesspolicy.json" -templateParameterFile "$PSScriptRoot\ftpreceiveadapterftp.apiconnectionaccesspolicy.dev.parameters.json" -deploymentName "ftpreceiveadapterftp.apicaccesspolicy.uksouth.aff"