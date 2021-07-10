<#
.SYNOPSIS
Invokes the deployment of the ftp receive api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-FtpSendAdapter-ApiConnectionAccessPolicy.ps1
#>

& $PSScriptRoot\New-FtpSendAdapter-ApiConnectionAccessPolicy.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-aff" -templateFile "$PSScriptRoot\ftpsendadapter.apiconnectionaccesspolicy.json" -templateParameterFile "$PSScriptRoot\ftpsendadapter.apiconnectionaccesspolicy.dev.parameters.json" -deploymentName "ftpsendadapter.apicaccesspolicy.uksouth.aff"