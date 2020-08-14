# Create a VM by using the Azure Command-Line Interface (CLI).
# Deploy a Docker container image to Azure Container Registry.
# Deploy a container from a container image in Container Registry by using Container Instances.
az account set -s "3f96110b-d3c2-4772-bd71-d11212d23f47"
$Name = "ContainerCompute"
$Location = "EastUS"
$Suffix = "awmc"
az group create -n $Name -l $Location

#create a vm
#List available images
az vm image list
<#
  {
    "offer": "debian-10",
    "publisher": "Debian",
    "sku": "10",
    "urn": "Debian:debian-10:10:latest",
    "urnAlias": "Debian",
    "version": "latest"
  },
#>
$image = "Debian:debian-10:10:latest"
az vm create -g $Name -l $Location -n quickvm --image $image --admin-username student --admin-password StudentPa55w.rd --size Standard_D4s_v3
#use SHOW to show detailed output, as opposed to LIST
az vm show -g $Name -n quickvm
#list IP addresses associated with VMs
az vm list-ip-addresses -g $name -n quickvm 
$ipAddress = az vm list-ip-addresses -g $name -n quickvm --query '[].{ip:virtualMachine.network.publicIpAddresses[0].ipAddress}' -o tsv
ssh student@$ipAddress
uname -a && exit

#Create a docer container image and deploy it to container registry
#BELOW IN AZURE CLOUD SHELL (BASH)
cd ~/clouddrive
mkdir ipcheck
cd ipcheck
dotnet new console -n ipcheck -o .
code .
dotnet run 
touch DockerFile
<#
# Start using the .NET Core 2.2 SDK container image
FROM mcr.microsoft.com/dotnet/core/sdk:2.2-alpine AS build

# Change current working directory
WORKDIR /app

# Copy existing files from host machine
COPY . ./

# Publish application to the "out" folder
RUN dotnet publish --configuration Release --output out

# Start container by running application DLL
ENTRYPOINT ["dotnet", "out/ipcheck.dll"]
#>

#Create a container registry resource
az acr create -g $name -n "$name$suffix" -l $Location --sku Basic
#Get container registry metadata

#Deploy a docker container image to container registry
#AZURE CLOUD SHELL (BASH)
name=ContainerCompute
acrName=$(az acr list -g $name --query "max_by([], &creationDate).name" --output tsv)
cd ~/clouddrive/ipcheck
az acr build -g $name --registry $acrName --image ipcheck:latest .

#az group delete -n $Name --no-wait -y