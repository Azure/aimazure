
<#
.SYNOPSIS
Tests the file paths for chocolatey ensuring they are valid.

.DESCRIPTION
When chocolatey packages are installed they are unpacked to a temporary directory. 
This along with the length of path names can exceed the windows 260 limit. This script tests the files in the build to ensure that are valid.

.PARAMETER templateRootDirectory
The route directory the templates are stored in.

.PARAMETER chocoCacheOffset
The amount of characters taken up by the chocolatey temporary cache directory.

.EXAMPLE
.\Test-ChocolateyFilePaths.ps1 -templateRootDirectory "c:\temp" -chocoCacheOffset 200
#>
[CmdletBinding(SupportsShouldProcess = $true)]
Param(
    [parameter(Mandatory = $true)]
    [string] $templateRootDirectory,
    [parameter(Mandatory = $true)]
    [int] $chocoCacheOffset
)

# Convert relative paths.
if (![System.IO.Path]::IsPathRooted($templateRootDirectory)) {
    # The path is relative so build the absolute path.
    $templateRootDirectory = Join-Path -Path $PSScriptRoot -ChildPath $templateRootDirectory -Resolve
}

$invalidFileCount = 0
$files = Get-ChildItem -Path $templateRootDirectory -Recurse -File

# Loop through the files.
foreach ($file in $files) {
    if ( ($file.FullName.length - $templateRootDirectory.length) -gt $chocoCacheOffset) {
        Write-Error "Invalid file: $($file.FullName)"
        $invalidFileCount++
    }
}

# Report an error if required.
if ($invalidFileCount -gt 0) {
    $errorMessage = "$invalidFileCount invalid files found. The maximum length of the path for the file from $templateRootDirectory is $chocoCacheOffset characters"
    Write-Error $errorMessage
    throw $errorMessage
}
