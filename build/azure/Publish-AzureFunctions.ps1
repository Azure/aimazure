<#
.SYNOPSIS
Publishes the Azure Functions code and then zips them up ready for deployment.

.DESCRIPTION
The first step of this script is to run 'dotnet publish' on each of the Azure Function projects.
It then zips up the published directory and copies the zip file into the template folder which
is packaged as a Chocolatey package as part of the CI build.

.EXAMPLE
./Publish-AzureFunctions.ps1
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $false)]
    [string] $output = "dist\functions",
    [parameter(Mandatory = $false)]
    [bool] $debugBuild = $false
)

# If output path is default, resolve to local path
$outputPath = $output
if ($output -eq "dist\functions")
{
    $cwd = Get-Location
    $outputPath = Join-Path $cwd $output
}

# Publish each of the Functions projects
$functionProjects = @(
    @{
        Project = (Resolve-Path ".\src\messagebus\routingmanager\functions\Microsoft.AzureIntegrationMigration.FunctionApp.RoutingManager")
        Template = (Resolve-Path ".\templates\messagebus\routingmanager")
    },
    @{
        Project = (Resolve-Path ".\src\messagebus\messagingmanager\functions\Microsoft.AzureIntegrationMigration.FunctionApp.MessagingManager")
        Template = (Resolve-Path ".\templates\messagebus\messagingmanager")
    })

foreach ($functionProject in $functionProjects)
{
    $projectName = (Split-Path $($functionProject.Project) -Leaf)
    $publishPath = Join-Path $outputPath $projectName
    New-Item -Path "$publishPath" -ItemType "directory" -Force

    Write-Host "Publishing project $($functionProject.Project) to $publishPath"

    # Debug or Release configuration?
    if ($debugBuild)
    {
        dotnet publish $($functionProject.Project) -o $publishPath
    }
    else
    {
        dotnet publish $($functionProject.Project) -o $publishPath -c Release
    }
    
    # Zip up the published project
    $zip = "$projectName.zip"
    $publishZip = Join-Path (Resolve-Path $output) $zip

    # Remove old one if it exists
    if (Test-Path $publishZip)
    {
        Write-Host "Removing old zip file $publishZip"
        Remove-item $publishZip
    }

    Write-Host "Creating zip file $publishZip"

    # Compress directory
    Add-Type -assembly "System.IO.Compression.FileSystem"
    [IO.Compression.ZipFile]::CreateFromDirectory($publishPath, $publishZip)

    Write-Host "Copying zip file $publishZip to template folder $($functionProject.Template)"

    # Copying zip file to template
    Copy-Item $publishZip $($functionProject.Template)
}
