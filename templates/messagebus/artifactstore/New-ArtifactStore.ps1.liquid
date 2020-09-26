<#
.SYNOPSIS
Creates an artifact store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER templateFile
Path to the ARM template that needs to be deployed.

.PARAMETER templateParameterFile
Path to the ARM template parameter file that contains the parameter values related to the template file.

.PARAMETER resourceGroup
The resource group to deploy to.

.PARAMETER deploymentName
The name used to identify this instance of the deployment.

.EXAMPLE
New-ArtifactStore.ps1 -templateFile ".\artifactstore.json" -templateParameterFile ".\artifactstore.dev.parameters.json" -resourceGroup "rg-aimmsgbus-dev-uksouth" -deploymentName "messagebusservice.plan.uksouth.xxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $templateFile,
    [parameter(Mandatory = $true)]
    [string] $templateParameterFile,
    [parameter(Mandatory = $true)]
    [string] $resourceGroup,
    [parameter(Mandatory = $true)]
    [string] $deploymentName
)

Write-Host "Deploying the artifact store`r`n Template File: $templateFile`r`n Parameter File: $templateParameterFile`r`n Resource Group: $resourceGroup`r`n Deployment Name: $deploymentName`r`n"

az deployment group create --template-file "$templateFile" --parameters "$templateParameterFile" --resource-group "$resourceGroup" --name $deploymentName

Write-Host "Deployment complete"