<#
.SYNOPSIS
Tears down the Role resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Remove-MessageBusService-Role.ps1 -role "Get Logic App Callback Url xxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $role
)

$resourceExists = az role definition list --name "$role" --custom-role-only true

if ($resourceExists) {
    Write-Host "Removing the role $role"

    az role definition delete --name "$role"

    Write-Host "Removed the role $role"
}
else {
    Write-Host "The role $role does not exist in the subscription"
}
