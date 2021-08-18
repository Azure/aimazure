<#
.SYNOPSIS
Invokes the deployment of the sftp receive api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-SsftpReceiveAdapterSsftp-ApiConnectionAccessPolicy.ps1
#>

& $PSScriptRoot\New-SsftpReceiveAdapterSsftp-ApiConnectionAccessPolicy.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-aff" -templateFile "$PSScriptRoot\sftpreceiveadaptersftp.apiconnectionaccesspolicy.json" -templateParameterFile "$PSScriptRoot\sftpreceiveadaptersftp.apiconnectionaccesspolicy.dev.parameters.json" -deploymentName "sftpreceiveadaptersftp.apicaccesspolicy.uksouth.aff"