<#
.SYNOPSIS
Removes a role assignment from the specified resource group for the managed identity of the API Management service.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER subscriptionId
The Azure subscription ID where the resource group is located.

.PARAMETER resourceGroupName
Name of the resource group for the role assignment scope.

.PARAMETER name
Name of the API Management service that will be used for the operation.

.PARAMETER messageBusResourceGroupName
Name of the resource group where the API Management service is located.

.PARAMETER role
The role to delete from the resource group for the API Management service managed identity.

.EXAMPLE
./Remove-MessageBusService-ApiManagement-RoleAssignment.ps1 -subscriptionId "<azure-subs-id>" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -name "apim-aimmsgbussvc-dev" -messageBusResourceGroupName "rg-aimmsgbus-dev-uksouth" -role "Get Logic App Callback Url xxxxx"
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
    [string] $messageBusResourceGroupName,
    [parameter(Mandatory = $true)]
    [string] $role
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

Write-Host "Getting managed identity principal ID for API Management service $name"

$principalId = az apim show --name $name --resource-group $messageBusResourceGroupName | ConvertFrom-Json | Select-Object -ExpandProperty identity | Select-Object -ExpandProperty principalId

# Reset console colour because the show command breaks the colours and outputs black on black
[Console]::ResetColor()

if ($principalId) {
    Write-Host "Principal ID is $principalId"
}
else {
    throw "Unable to get managed identity principal ID for $name"
}

Write-Host "Deleting role assignment for $principalId for role $role from resource group $resourceGroupName"

az role assignment delete --assignee $principalId --role "$role" --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName --yes

Write-Host "Deleted managed identity of API Management service $name from $resourceGroupName"
