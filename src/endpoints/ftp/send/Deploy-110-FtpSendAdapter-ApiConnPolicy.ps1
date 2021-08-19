<#
.SYNOPSIS
Invokes the deployment of the ftp receive api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-FtpSendAdapter-ApiConnPolicy.ps1
#>

& $PSScriptRoot\New-FtpSendAdapter-ApiConnPolicy.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-aff" -templateFile "$PSScriptRoot\ftpsendadapter.apiconnpolicy.json" -templateParameterFile "$PSScriptRoot\ftpsendadapter.apiconnpolicy.dev.parameters.json" -deploymentName "ftpsendadapter.apicaccesspolicy.uksouth.aff"