<#
.SYNOPSIS
Creates an sftp api connection for an application.

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
.\New-SftpReceiveAdapterSftp-ApiConnection.ps1 -resourceGroupName "rg-aimapp-aim-sftppassthru-dev-uksouth" -templateFile ".\sftpreceiveadaptersftp.apiconnection.json" -templateParameterFile ".\sftpreceiveadaptersftp.apiconnection.dev.parameters.json" -deploymentName "sftpreceiveadaptersftp.apiconnection.xxx"
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

Write-Host "Deploying an sftp api connection`r`n Template File: $templateFile`r`n Parameter File: $templateParameterFile`r`n Deployment Name: $deploymentName`r`n"

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters $templateParameterFile --name $deploymentName

Write-Host "Deployment complete"