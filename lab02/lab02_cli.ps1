$root='D:\Dropbox\Source\AZ203'
#! EXERCISE 1
# Create Resource Group
$Name = 'Serverless'
$Location = 'EastUS'
$Suffix = 'awmc'
$namesuf=$name+$Suffix
az group create -n $Name -l $Location
# Create a storage account
az storage account create --resource-group $Name --location $Location --name "funcstor$Suffix" --kind StorageV2 --sku Standard_LRS --access-tier Hot
#Create a function app
<#
The version of dotnet used depends on the value of --functions-version
Providing this parameter will automatically create a consumption plan named "$Location"+"Plan"
#>
az functionapp create --name "funclogic$Suffix" -g $Name --storage-account "funcstor$Suffix" --functions-version 3 --runtime dotnet --consumption-plan-location $Location  --os-type Windows

az group delete -g $Name -y