<#
.SYNOPSIS
Invokes the deployment of the sftp receive api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-SftpSendAdapter-ApiConnectionAccessPolicy.ps1
#>

& $PSScriptRoot\New-SftpSendAdapter-ApiConnectionAccessPolicy.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-aff" -templateFile "$PSScriptRoot\sftpsendadapter.apiconnectionaccesspolicy.json" -templateParameterFile "$PSScriptRoot\sftpsendadapter.apiconnectionaccesspolicy.dev.parameters.json" -deploymentName "sftpsendadapter.apicaccesspolicy.uksouth.aff"