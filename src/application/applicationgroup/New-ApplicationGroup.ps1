<#
.SYNOPSIS
Creates a resource group for an application.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER templateFile
Path to the ARM template that needs to be deployed.

.PARAMETER templateParameterFile
Path to the ARM template parameter file that contains the parameter values related to the template file.

.PARAMETER deploymentName
The name used to identify this instance of the deployment.

.PARAMETER deploymentDataLocation
The location to store the deployment data.

.EXAMPLE
New-ApplicationGroup.ps1 -templateFile ".\applicationgroup.json" -templateParameterFile ".\applicationgroup.dev.parameters" -deploymentName "applicationgroup" -deploymentDataLocation "UK South"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $templateFile,
    [parameter(Mandatory = $true)]
    [string] $templateParameterFile,
    [parameter(Mandatory = $true)]
    [string] $deploymentDataLocation,
    [parameter(Mandatory = $true)]
    [string] $deploymentName
)

Write-Host "Deploying the application group`r`n Template File: $templateFile`r`n Parameter File: $templateParameterFile`r`n Deployment Name: $deploymentName`r`n Deployment Data Location: $deploymentDataLocation`r`n"

az deployment sub create --template-file $templateFile --parameters $templateParameterFile --name $deploymentName --location $deploymentDataLocation

Write-Host "Deployment complete"