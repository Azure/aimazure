<#
.SYNOPSIS
Creates an on-premise data gateway.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER resourceGroupName
The name of the Azure resource group to deploy the data gateway to.

.PARAMETER subscriptionId
"<azure-subs-id>"

.PARAMETER templateFile
Path to the ARM template that needs to be deployed.

.PARAMETER templateParameterFile
Path to the ARM template parameter file that contains the parameter values related to the template file.

.PARAMETER connectionGatewayInstallationDisplayName
The name of the connection gateway installation to link the new data gateway to.

.PARAMETER connectionGatewayInstallationLocation
The location of the connection gateway installation to link the new data gateway to.

.PARAMETER deploymentName
The name used to identify this instance of the deployment.
    
.EXAMPLE
.\New-DataGateway.ps1 -resourceGroupName $params.resourceGroupName -subscriptionId "<azure-subs-id>" -connectionGatewayInstallationDisplayName "cgw-aimmsgbus-dev-uksouth-xxxx" -connectionGatewayInstallationLocation "uksouth" -templateFile "datagateway.onpremisedatagateway.json" -templateParameterFile "datagateway.onpremisedatagateway.dev.parameters.json" -deploymentName "datagateway.uksouth.xxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $resourceGroupName,
    [parameter(Mandatory = $true)]
    [AllowNull()]
    [AllowEmptyString()]
    [string] $subscriptionId,
    [parameter(Mandatory = $true)]    
    [string] $templateFile,
    [parameter(Mandatory = $true)]
    [string] $templateParameterFile,        
    [parameter(Mandatory = $true)]    
    [string] $connectionGatewayInstallationDisplayName,
    [parameter(Mandatory = $true)]    
    [string] $connectionGatewayInstallationLocation,
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

$connectionGatewayInstallationName = az rest --method get --uri /subscriptions/$subscriptionId/providers/Microsoft.Web/locations/$connectionGatewayInstallationLocation/connectionGatewayInstallations?api-version=2016-06-01 --query "value[?properties.displayName=='$connectionGatewayInstallationDisplayName'].{Name:name} | [0]" -o tsv

if ($connectionGatewayInstallationName -eq "") {
    throw "No connection gateway installation found in location: $connectionGatewayInstallationLocation with the display name: $connectionGatewayInstallationDisplayName "
}

Write-Host "Deploying the data gateway `r`n Template File: $templateFile`r`n Parameter File: $templateParameterFile`r`n Deployment Name: $deploymentName" 

az deployment group create --resource-group $resourceGroupName --template-file $templateFile --parameters $templateParameterFile --parameters "connectionGatewayInstallationId=$connectionGatewayInstallationName" --parameters "connectionGatewayInstallationLocation=$connectionGatewayInstallationLocation" --name $deploymentName

Write-Host "Deployment complete"