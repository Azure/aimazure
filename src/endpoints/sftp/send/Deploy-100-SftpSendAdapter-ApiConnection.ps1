<#
.SYNOPSIS
Invokes the deployment of an sftp connector.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
Deploy-100-SftpSendAdapter-ApiConnection.ps1
#>

& $PSScriptRoot\New-SftpSendAdapter-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-sftppassthru-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\sftpsendadapter.apiconnection.json" -templateParameterFile "$PSScriptRoot\sftpsendadapter.apiconnection.dev.parameters.json" -deploymentName "sftpsendadapter.apic.xxxxx"