<#
.SYNOPSIS
Invokes the deployment of the filesystem send api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-FileSendAdapter-ApiConnectionAccessPolicy.ps1
#>

& $PSScriptRoot\New-FileSendAdapter-ApiConnectionAccessPolicy.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-aff" -templateFile "$PSScriptRoot\filesystemsendadapter.apiconnectionaccesspolicy.json" -templateParameterFile "$PSScriptRoot\filesystemsendadapter.apiconnectionaccesspolicy.dev.parameters.json" -deploymentName "filesystemsendadapter.apicaccesspolicy.uksouth.aff"