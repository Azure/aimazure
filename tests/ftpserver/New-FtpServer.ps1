<#
.SYNOPSIS
Creates an ftp server.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER ftpServerName
The name to assign to the virtual machine running the ftp server.

.PARAMETER resourceGroupName
The resource group to create.

.PARAMETER location
The location for the resource group.

.PARAMETER publicDnsName
The public dns to assign to the ftp server.

.PARAMETER adminUserName
The admin user name for the ftp server.

.PARAMETER adminUserPassword
The admin password for the ftp server.

.PARAMETER ftpUserName
The ftp user name.

.PARAMETER ftpUserPassword
The ftp user password.

.PARAMETER osImageUrn
The urn of the OS image used to build the ftp server from. 

.PARAMETER tags
The tags to apply to the resources.

.EXAMPLE
.\New-FtpServer.ps1 -ftpServerName "vmaimtestftpserver001" -resourceGroupName "rg-aimftpserver-dev-uksouth" -location "UK South" -publicDnsName "abc.aim.ftpserver" -adminUserName "azureuser" -adminUserPassword "Password1234#" -ftpUserName "ftpuser -ftpUserPassword "password1234#" -osImageUrn "/subscriptions/<subscription id>/resourceGroups/rg-aimsharedimages-dev-uksouth/providers/Microsoft.Compute/galleries/sigaimimagesdevuksouth/images/img-aimftpserver-dev-uk-south/versions/1.0.0"
#>
[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]
    [string] $ftpServerName,
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName, 
    [parameter(Mandatory = $true)]
    [string] $location, 
    [parameter(Mandatory = $true)]
    [string] $publicDnsName, 
    [parameter(Mandatory = $true)]
    [string] $adminUserName, 
    [parameter(Mandatory = $true)]
    [string] $adminUserPassword,
    [parameter(Mandatory = $true)] 
    [string] $ftpUserName, 
    [parameter(Mandatory = $true)]
    [string] $ftpUserPassword, 
    [parameter(Mandatory = $true)]
    [string] $osImageUrn, 
    [parameter(Mandatory = $false)]
    [string[]] $tags = ""
)

# Create the resource group
Write-Host "Creating the resource group $vmImageResourceGroup"
az group create --name $resourceGroupName --location $location --tags $tags

# Create the VM
Write-Host "Creating the VM $ftpServerName"
az vm create --resource-group $resourceGroupName --name $ftpServerName --image $osImageUrn --size Standard_B1ls --public-ip-address-dns-name $publicDnsName --admin-username $adminUserName --admin-password $adminUserPassword --generate-ssh-keys --tags $tags

# Open the ports
Write-Host "Opening the ports"
az vm open-port -g $resourceGroupName -n $ftpServerName --port 10000-10010 --priority 100
az vm open-port -g $resourceGroupName -n $ftpServerName --port 21 --priority 101

# Create the ftp user
Write-Host "Creating the ftp user"
$addUSerCmd = "sudo useradd -m -p `$(openssl passwd -1 $ftpUserPassword) $ftpUserName"
az vm run-command invoke -g $resourceGroupName -n $ftpServerName --command-id RunShellScript --scripts $addUSerCmd

# Get the public dns name for the VM
Write-Host "Finding the fqdn for the VM"
$fqdn = az vm show -d -g $resourceGroupName -n $ftpServerName --query fqdns -o tsv

# Add to the vsftpd config
Write-Host "Adding the fqdn to the vsftpd config"
az vm run-command invoke -g $resourceGroupName -n $ftpServerName --command-id RunShellScript --scripts "echo `"pasv_address=$fqdn`" >> /etc/vsftpd.conf"

# Restart vsftpd
Write-Host "Restarting vsftpd"
az vm run-command invoke -g $resourceGroupName -n $ftpServerName --command-id RunShellScript --scripts "service vsftpd restart"

Write-Host "Deployment complete. The fqdn for the VM is $fqdn"