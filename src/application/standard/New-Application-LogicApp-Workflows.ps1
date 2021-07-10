<#
.SYNOPSIS
Creates the Application Logic App Workflows.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER workflowFolder
Location of the folder containing the Logic App Workflows.

.EXAMPLE
.\New-Application-LogicApp-Workflows.ps1 -resourceGroupName "rg-aimapp-application-dev-uksouth-xxxxx" -resourceName "logic-application-dev-xxxxx" -workflowFolder "$PSScriptRoot\application.logic.workflows"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $resourceName,	
	[parameter(Mandatory = $true)]
    [string] $workflowFolder
)

Write-Host "Creating a ZIP file from the workflow folder"
# create the zip
$zipFile = "$workflowFolder.zip"
if(Test-path $zipFile) {Remove-item $zipFile}
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($workflowFolder, $zipFile)

Write-Host "Zip File creation complete"

Write-Host "Uploading the Aim-FtpPassthru logic app zip package $zipFile"

if (!(Test-Path $zipFile)) {
    throw "Zip file $zipFile doesn't exist, unable to upload"
}

az logicapp deployment source config-zip --resource-group $resourceGroupName --name $resourceName --src $zipFile

Write-Host "Upload complete"