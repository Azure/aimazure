<#
.SYNOPSIS
Creates a Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER templateFile
Path to the ARM template that needs to be deployed.

.PARAMETER templateParameterFile
Path to the ARM template parameter file that contains the parameter values related to the template file.

.PARAMETER deploymentName
The name used to identify this instance of the deployment.

.EXAMPLE
.\New-XmlMessageTranslatorLite-LogicApp.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-xxxxx" -templateFile ".\xmlmessagetranslatorlite.logicapp.json" -templateParameterFile ".\xmlmessagetranslatorlite.logicapp.dev.parameters" -deploymentName "xmlmessagetranslator.logicapp.uksouth.xxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]    
    [string] $templateFile,
    [parameter(Mandatory = $true)]
    [string] $templateParameterFile,
    [parameter(Mandatory = $true)]
    [string] $deploymentName    
)

Write-Host "Deploying the xml message translator lite Logic App`r`n Template File: $templateFile`r`n Parameter File: $templateParameterFile`r`n Deployment Name: $deploymentName`r`n"

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters $templateParameterFile --name $deploymentName 

Write-Host "Deployment complete"