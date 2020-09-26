<#
.SYNOPSIS
Creates a App Config resource for the routing store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER subscriptionId
The Azure subscription ID where the Key Vault service is located.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER appConfigName
The name of the Azure App Configuration service.

.PARAMETER keyVaultName
The name of the Azure Key Vault service.

.PARAMETER templateFile
Path to the ARM template that needs to be deployed.

.PARAMETER templateParameterFile
Path to the ARM template parameter file that contains the parameter values related to the template file.

.PARAMETER deploymentName
The name used to identify this instance of the deployment.

.EXAMPLE
./New-RoutingStore-AppConfig.ps1 -subscriptionId "<azure-subs-id>" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -appConfigName "appcfg-aimrstore-dev" -keyVaultName "kv-aimrstore-dev" -templateFile ".\routingstore.appcfg.json" -templateParameterFile ".\routingstore.appcfg.dev.parameters" -deploymentName "routingstore.appcfg"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [AllowNull()]
    [AllowEmptyString()]
    [string] $subscriptionId,
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $appConfigName,
    [parameter(Mandatory = $true)]
    [string] $keyVaultName,
    [parameter(Mandatory = $true)]
    [string] $templateFile,
    [parameter(Mandatory = $true)]
    [string] $templateParameterFile,
    [parameter(Mandatory = $true)]
    [string] $deploymentName
)

if ($subscriptionId -eq "") {
    Write-Host "No Azure subscription ID specified, finding from current active subscription"

    $subscriptionId = az account show | ConvertFrom-Json | Select-Object -ExpandProperty id

    if ($subscriptionId) {
        Write-Host "Found subscription ID $subscriptionId"
    }
    else {
        throw "No subscription ID found, an active subscription may not have been set in the Azure CLI"
    }
}

Write-Host "Deploying the routing store`r`n Template File: $templateFile`r`n Parameter File: $templateParameterFile`r`n Deployment Name: $deploymentName`r`n"

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters $templateParameterFile --name $deploymentName

Write-Host "Deployment complete"

Write-Host "Getting managed identity principal ID for App Configuration resource $appConfigName"

$principalId = az appconfig show --name $appConfigName --resource-group $resourceGroupName | ConvertFrom-Json | Select-Object -ExpandProperty identity | Select-Object -ExpandProperty principalId

if ($principalId) {
    Write-Host "Principal ID is $principalId"
}
else {
    throw "Unable to get managed identity principal ID for $appConfigName"
}

$role = "Key Vault Secrets User (preview)"

Write-Host "Adding role assignment for $principalId to role $role for Key Vault resource $keyVaultName"

az role assignment create --assignee $principalId --role "$role" --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.KeyVault/vaults/$keyVaultName

Write-Host "Assigned managed identity of App Configuration resource $appConfigName to $keyVaultName"