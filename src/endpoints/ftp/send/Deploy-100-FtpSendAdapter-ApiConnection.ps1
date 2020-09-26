<#
.SYNOPSIS
Invokes the deployment of an ftp connector.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
Deploy-100-FtpSendAdapter-ApiConnection.ps1
#>

& $PSScriptRoot\New-FtpSendAdapter-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-ftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\ftpsendadapter.apiconnection.json" -templateParameterFile "$PSScriptRoot\ftpsendadapter.apiconnection.dev.parameters.json" -deploymentName "ftpsendadapter.apic.xxxxx"