<#
.SYNOPSIS
Invokes the deployment of the sftp receive api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-SsftpReceiveAdapterSsftp-ApiConnPolicy.ps1
#>

& $PSScriptRoot\New-SsftpReceiveAdapterSsftp-ApiConnPolicy.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-aff" -templateFile "$PSScriptRoot\sftpreceiveadaptersftp.apiconnpolicy.json" -templateParameterFile "$PSScriptRoot\sftpreceiveadaptersftp.apiconnpolicy.dev.parameters.json" -deploymentName "sftpreceiveadaptersftp.apicaccesspolicy.uksouth.aff"