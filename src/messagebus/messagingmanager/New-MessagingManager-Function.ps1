<#
.SYNOPSIS
Creates a Function resource which implements the messaging manager operations.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER resourceName
Name of the Function App.

.PARAMETER templateFile
Path to the ARM template that needs to be deployed.

.PARAMETER templateParameterFile
Path to the ARM template parameter file that contains the parameter values related to the template file.

.PARAMETER deploymentName
The name used to identify this instance of the deployment.

.PARAMETER zipFile
Name of the zip file containing the Function App.

.EXAMPLE
./New-MessagingManager-Function.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -templateFile ".\messagingmanager.func.json" -templateParameterFile ".\messagingmanager.func.dev.parameters" -deploymentName "messagingmanager.func"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName,
    [parameter(Mandatory = $true)]    
    [string] $templateFile,
    [parameter(Mandatory = $true)]
    [string] $templateParameterFile,
    [parameter(Mandatory = $true)]
    [string] $deploymentName,
    [parameter(Mandatory = $true)]
    [string] $zipFile
)

Write-Host "Deploying the messaging manager function`r`n Template File: $templateFile`r`n Parameter File: $templateParameterFile`r`n Deployment Name: $deploymentName`r`n"

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters $templateParameterFile --name $deploymentName

Write-Host "Deployment complete"

Write-Host "Uploading the messaging manager function zip package $zipFile"

if (!(Test-Path $zipFile)) {
    throw "Zip file $zipFile doesn't exist, unable to upload"
}

az functionapp deployment source config-zip --resource-group $resourceGroupName --name $resourceName --src $zipFile

Write-Host "Upload complete"
