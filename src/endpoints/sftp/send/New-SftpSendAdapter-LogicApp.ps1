<#
.SYNOPSIS
Creates an sftp adapter for an application.

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
./New-SftpSendAdapter-LogicApp.ps1 -resourceGroupName "rg-aimapp-aim-sftppassthru-dev-uksouth-xxxxx" -templateFile ".\sftpadapter.json" -templateParameterFile ".\sftpadapter.dev.parameters.json" -deploymentName "sftpadapter"
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
    [string] $keyVaultName,
    [parameter(Mandatory = $true)]
    [string] $keyVaultApimSubscriptionSecretName,
    [parameter(Mandatory = $true)]
    [string] $deploymentName
)

Write-Host "Getting the subscription from Key Vault for the routing slip router Logic App"

$apimSubscriptionKey = az keyvault secret show --name $keyVaultApimSubscriptionSecretName --vault-name $keyVaultName --query value
if (!$apimSubscriptionKey) {
    throw "Unable to get a secret from the vault $keyVaultName with the name $keyVaultApimSubscriptionSecretName"
}

Write-Host "Deploying an sftp adapter`r`n Template File: $templateFile`r`n Parameter File: $templateParameterFile`r`n Deployment Name: $deploymentName`r`n"

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters $templateParameterFile "apimSubscriptionKey=$apimSubscriptionKey" --name $deploymentName

Write-Host "Deployment complete"