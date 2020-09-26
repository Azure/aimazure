<#
.SYNOPSIS
Creates an API Management resource for use by various AIM components.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER subscriptionId
The Azure subscription ID where the App Configuration service is located.

.PARAMETER resourceGroupName
Name of the resource group where the resources will be created.

.PARAMETER name
Name of the API Management service that will be created.

.PARAMETER location
Location where the resource will be created.

.PARAMETER appConfigName
The name of the Azure App Configuration service.

.PARAMETER keyVaultName
The name of the Azure Key Vault service.

.PARAMETER publisherName
Name of the publisher organisation.

.PARAMETER publisherEmail
Email address that will receive emails from Azure when the service is published.

.PARAMETER sku
The SKU level for the API Management service.

.PARAMETER skuCapacity
The SKU capacity level for the API Management service.

.PARAMETER tags
The tags to apply to the API Management service.

.EXAMPLE
./New-MessageBusService-ApiManagement.ps1 -subscriptionId "<azure-subs-id>" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -name "apim-aimmsgbussvc-dev" -location "UK South" -appConfigName "appcfg-aimrstore-dev"  -keyVaultName "kv-aimrstore-dev" -publisherName "Microsoft" -publisherEmail "person@constoso.com"
./New-MessageBusService-ApiManagement.ps1 -subscriptionId "<azure-subs-id>" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -name "apim-aimmsgbussvc-dev" -location "UK South" -appConfigName "appcfg-aimrstore-dev"  -keyVaultName "kv-aimrstore-dev" -publisherName "Microsoft" -publisherEmail "person@constoso.com" -sku "Premium" -skuCapacity 5
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
    [string] $name,
    [parameter(Mandatory = $true)]
    [string] $location,
    [parameter(Mandatory = $true)]
    [string] $appConfigName,
    [parameter(Mandatory = $true)]
    [string] $keyVaultName,
    [parameter(Mandatory = $true)]
    [string] $publisherName,
    [parameter(Mandatory = $true)]
    [string] $publisherEmail,
    [parameter(Mandatory = $false)]
    [string] $sku = "Developer",
    [parameter(Mandatory = $false)]
    [int] $skuCapacity = 1,
    [parameter(Mandatory = $false)]
    [string[]] $tags = ""
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

# --------------------------------------------------------------------------

Write-Host "Deploying the API management service"

az apim create --name $name --location $location --publisher-email $publisherEmail --publisher-name $publisherName --resource-group $resourceGroupName --sku-name $sku --sku-capacity $skuCapacity --tags $tags #--enable-managed-identity
if (!$?)
{
    # API Management is a global resource, so this may cause a failure if it already exists in
    # another subscription.
    throw "Deployment failed, aborting"
}

# Update apim instance to enable managed identities due to az CLI issue.
# https://github.com/Azure/azure-cli/issues/11614
az apim update --name $name --resource-group $resourceGroupName --enable-managed-identity

Write-Host "Deployment complete"

# --------------------------------------------------------------------------

Write-Host "Getting managed identity principal ID for API Management service $name"

$principalId = az apim show --name $name --resource-group $resourceGroupName | ConvertFrom-Json | Select-Object -ExpandProperty identity | Select-Object -ExpandProperty principalId

# Reset console colour because the show command breaks the colours and outputs black on black
[Console]::ResetColor()

if ($principalId) {
    Write-Host "Principal ID is $principalId"
}
else {
    throw "Unable to get managed identity principal ID for $name"
}

$role = "Contributor"

Write-Host "Adding role assignment for $principalId to role $role for App Configuration service $appConfigName"

az role assignment create --assignee $principalId --role "$role" --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.AppConfiguration/configurationStores/$appConfigName

Write-Host "Assigned managed identity of API Management service $name to $appConfigName"

# --------------------------------------------------------------------------

Write-Host "Uploading product subscription keys for API Management service $name products to Key Vault $keyVaultName"

$products = az rest -m GET -u https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.ApiManagement/service/$name/products?api-version=2018-01-01 | ConvertFrom-Json | Select-Object -ExpandProperty value
$subscriptions = az rest -m GET -u https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.ApiManagement/service/$name/subscriptions?api-version=2018-01-01 | ConvertFrom-Json | Select-Object -ExpandProperty value | Select-Object -ExpandProperty properties

if ($products -and $subscriptions) {
    Write-Host "Found products and subscriptions for API Management service $name"

    ForEach ($product in $products)
    {
        $productName = $product.name
        $subscriptionKey = $null

        Write-Host "Finding subscription key for product $productName"

        ForEach ($subscription in $subscriptions)
        {
            if ($subscription.productId -eq $product.Id) {
                Write-Host "Found subscription key for product $productName"

                $subscriptionKey = $subscription.primaryKey

                Break
            }
        }

        if ($subscriptionKey) {
            Write-Host "Uploading subscription key for product $productName to Key Vault"

            az keyvault secret set --name "aim-apim-subscriptionkey-$productName" --vault-name $keyVaultName --value "$subscriptionKey"
        }
        else {
            throw "Failed to find subscription key for product $productName"
        }
    }
}
else {
    throw "Failed to get products and subscriptions for API Management service $name"
}