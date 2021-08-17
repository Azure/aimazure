<#
.SYNOPSIS
Assigns the Logic App to the given role for an App Config Store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER appConfigStoreName
Name of the app config store to assign permissions to.

.PARAMETER logicAppName
Name of the Logic App that will be granted permissions.

.PARAMETER roleName
Name of the Role that the Logic App will be assigned.

.EXAMPLE
.\New-AppConfigStore-RoleAssignment.ps1 -appConfigStoreName "appcfg-aimrstore-dev-xxxxx" -logicAppName "logic-messagebus-dev-xxxxx" -roleName "Contributor"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $appConfigStoreName,
    [parameter(Mandatory = $true)]
    [string] $logicAppName,
	[parameter(Mandatory = $true)]
    [string] $roleName
)
Write-Host "Assigning the Logic App $logicAppName to the $roleName role for the App Config Store $appConfigStoreName"

Write-Host "Getting the ResourceId for the App Config Store $appConfigStoreName"
$appConfigStoreResourceId = az resource list --name $appConfigStoreName --query "[0].id" --output tsv
if (!$appConfigStoreResourceId) {
    throw "Unable to get the ResourceId for the App Config Store $appConfigStoreName"
}

Write-Host "Getting the ManagedIdentity ObjectId for the LogicApp $logicAppName"
$logicAppObjectId = az ad sp list --filter "displayName eq '$logicAppName' and servicePrincipalType eq 'ManagedIdentity'" --query "[0].objectId" --output tsv
if (!$logicAppObjectId) {
    throw "Unable to get the ObjectId for the Managed Identity for the Logic App $logicAppName"
}

Write-Host "Assigning the $roleName role to the Logic App $logicAppName for the App Config Store $appConfigStoreName"
az role assignment create --role $roleName --assignee $logicAppObjectId --scope $appConfigStoreResourceId

Write-Host "Finished assigning permissions"