<#
.SYNOPSIS
Invokes the deployment of the filesystem send api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-110-FileSendAdapter-ApiConnPolicy.ps1
#>

& $PSScriptRoot\New-FileSendAdapter-ApiConnPolicy.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-aff" -templateFile "$PSScriptRoot\filesystemsendadapter.apiconnpolicy.json" -templateParameterFile "$PSScriptRoot\filesystemsendadapter.apiconnpolicy.dev.parameters.json" -deploymentName "filesystemsendadapter.apicaccesspolicy.uksouth.aff"