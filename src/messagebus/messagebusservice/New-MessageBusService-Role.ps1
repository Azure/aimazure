<#
.SYNOPSIS
Creates a custom Role resource for use by API Management service.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER subscriptionId
The Azure subscription ID where the Key Vault service is located.

.EXAMPLE
./New-MessageBusService-Role.ps1 -subscriptionId "<azure-subs-id>" -role "Get Logic App Callback Url xxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [AllowNull()]
    [AllowEmptyString()]
    [string] $subscriptionId,
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

Write-Host "Load role definition and update subscription scope"

$roleDefinition = Get-Content -Raw -Path "$PSScriptRoot\messagebusservice.logicappsrole.json" | ConvertFrom-Json

if ($roleDefinition) {
    Write-Host "Updating role name to $role"

    $roleDefinition.Name = "$role"
    
    Write-Host "Updating subscription assignable scope to $subscriptionId"

    $roleDefinition.AssignableScopes[0] = "/subscriptions/$subscriptionId"
}
else {
    throw "Unable to load role definition"
}

Write-Host "Checking for existing role $role"

$resourceExists = az role definition list --name "$role" --custom-role-only true -o tsv

if ($resourceExists) {
    Write-Host "Updating the role $role"

    # When a command is invoked in PowerShell, there is a lot of removing of double quotes in strings when the command is
    # invoked.  There is also some weirdness around having spaces in values.  The replace calls escape the double quotes
    # and the spaces in the string, which allows it to work.  Key also is the -Compress on the ConvertTo-Json call so the
    # json is a single line string.
    az role definition update --role-definition ($roleDefinition | ConvertTo-Json -Compress).Replace('"', '\"').Replace(' ', '\u0020')
    if (!$?) {
        throw "Update failed, aborting"
    }

    Write-Host "Updated the role $role"
}
else {
    Write-Host "Deploying the role $role"

    # See above for comment on double quote and space escaping.
    az role definition create --role-definition ($roleDefinition | ConvertTo-Json -Compress).Replace('"', '\"').Replace(' ', '\u0020')
    if (!$?) {
        throw "Deployment failed, aborting"
    }
    
    Write-Host "Deployment complete"
}
