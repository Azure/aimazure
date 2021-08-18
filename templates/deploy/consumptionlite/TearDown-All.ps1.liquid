<#
.SYNOPSIS
Invokes the teardown of all resources from Azure.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure.

.PARAMETER minDeploymentPriority
The minimum priority number found in the file name to be deployed.

.PARAMETER maxDeploymentPriority
The maximum priority number found in the file name to be deployed.

.EXAMPLE
.\TearDown-All.ps1
.\TearDown-All.ps1 -minDeploymentPriority 10 -maxDeploymentPriority 200
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $false)]
    [int] $minDeploymentPriority = [int32]::MinValue,
    [parameter(Mandatory = $false)]
    [int] $maxDeploymentPriority = [int32]::MaxValue
)
{%- assign subscription_id = resource_template.parameters.azure_subscription_id -%}
{%- unless subscription_id == "" -%}
# Set the subscription.
az account set --subscription "{{ subscription_id }}"
{%- endunless -%}


class Template {
    [string]$FileName
    [string]$FullPath
    [int]$Priority

    Template(
        [string]$fileName,
        [string]$fullPath,
        [int]$priority
    ) {
        $this.FileName = $fileName
        $this.FullPath = $fullPath
        $this.Priority = $priority
    }
}

{%- assign array_separator = "||" %}
{%- assign resource_templates = find_all_resource_templates(model) -%}
{%- assign powershell_scripts = '' -%}
{%- for resource_template in resource_templates -%}
    {%- if resource_template.template_type == "microsoft.template.powershell" -%}
        {%- for resource_template_file in resource_template.resource_template_files -%}
            {%- assign powershell_script_file = resource_template_file | remove: ".liquid" | split: "/" | last -%}
            {%- assign powershell_script_cmd = "$PSScriptRoot/" | append: resource_template.output_path | append: "/" | append: powershell_script_file | append: array_separator -%}
            {%- assign powershell_scripts = powershell_scripts | append: powershell_script_cmd -%}
        {%- endfor -%}
    {%- endif -%}
{%- endfor -%}


# Read in the resources.
$filePaths = @(        
{%- for powershell_script in powershell_scripts | split: array_separator -%}
    "{{ powershell_script }}"
    {%- if forloop.last == false -%}
        ,{% capture newline %}{% endcapture %}
    {% endif -%}            
{%- endfor -%}
)

$templates = @()

# Extract the priority and file name from the template full path.
$filePaths | ForEach-Object {
    $fileName = Split-Path $_ -leaf

    if ($fileName -match 'TearDown-([0-9]*?)-(?:.*.ps1)' ) {
        $priority = $Matches.1
        $templates += [Template]::new($fileName, $_, $priority)
    }
}

# Run the scripts in descending order.
# Filter based on the min and max priority.
$templates | Where-Object { $_.Priority -ge $minDeploymentPriority } | Where-Object { $_.Priority -le $maxDeploymentPriority } | Sort-Object { $_.Priority } -Descending | Select-Object -ExpandProperty FullPath -Unique | ForEach-Object {
    & $_
    # The Azure CLI does not currently reset colors there is an issue raised: https://github.com/Azure/azure-cli/issues/13979
    # The following command manually resets colors.
    [Console]::ResetColor()
}