<#
.SYNOPSIS
Invokes the deployment of the sftp receive api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-SftpSendAdapter-ApiConnPolicy.ps1
#>

& $PSScriptRoot\New-SftpSendAdapter-ApiConnPolicy.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-aff" -templateFile "$PSScriptRoot\sftpsendadapter.apiconnpolicy.json" -templateParameterFile "$PSScriptRoot\sftpsendadapter.apiconnpolicy.dev.parameters.json" -deploymentName "sftpsendadapter.apicaccesspolicy.uksouth.aff"