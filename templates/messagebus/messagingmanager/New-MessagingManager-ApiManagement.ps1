<#
.SYNOPSIS
Creates an API resource in API Management for the messaging manager.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER subscriptionId
The Azure subscription ID where the API Management service is located.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER apimServiceName
The name of the API Management service.

.PARAMETER apiName
The name of the API being deployed.

.PARAMETER templateFile
Path to the ARM template that needs to be deployed.

.PARAMETER templateParameterFile
Path to the ARM template parameter file that contains the parameter values related to the template file.

.PARAMETER deploymentName
The name used to identify this instance of the deployment.

.EXAMPLE
./New-MessagingManager-ApiManagement.ps1 -subscriptionId "<azure-subs-id>" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -apimServiceName "apim-aimmsgbussvc-dev" -apiName "aimroutingmanager" -templateFile ".\routingmanager.apim.json" -templateParameterFile ".\routingmanager.apim.dev.parameters" -deploymentName "routingmanager.apim"
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
    [string] $apimServiceName,
    [parameter(Mandatory = $true)]
    [string] $apiName,
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

Write-Host "Deploying the API for the messaging manager`r`n Template File: $templateFile`r`n Parameter File: $templateParameterFile`r`n Deployment Name: $deploymentName`r`n"

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters $templateParameterFile --name $deploymentName

Write-Host "Deployment complete"

Write-Host "Associating the API Management service $apimServiceName products to the API $apiName"

$products = az rest -m GET -u https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.ApiManagement/service/$apimServiceName/products?api-version=2018-01-01 | ConvertFrom-Json | Select-Object -ExpandProperty value

if ($products) {
    Write-Host "Found products for API Management service $apimServiceName"

    ForEach ($product in $products) {
        $productName = $product.name

        Write-Host "Associating product $productName with the messaging manager API"

        # PowerShell doesn't like variable expansion when a ? follows the variable
        $url = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.ApiManagement/service/$apimServiceName/products/$productName/apis/" + $apiName + "?api-version=2018-01-01"
		
        az rest -m PUT -u $url
    }
}
else {
    throw "Failed to get products for API Management service $apimServiceName"
}