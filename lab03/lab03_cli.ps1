az account set -s "3f96110b-d3c2-4772-bd71-d11212d23f47"
$Name = "StorageMedia"
$Location = "EastUS"
$suffix = "awmc"
az group create -n $Name -l $Location

az storage account create -g $Name -n "mediastor$Suffix" -l $Location --kind StorageV2 --sku Standard_RAGRS --access-tier Hot
$primaryEndpoint = "https://mediastorawmc.blob.core.windows.net/"
$key = 'AM/p1oG8NTAUfW/X4Nnqpd0goEa7gREuOYYfygkuUaUPdu3NIzXbft5SzmlrYUzZXglpyBX81VDEQ0M3vV9JKA=='
cd "D:\Dropbox\Source\AZ203\allfiles\Labs\03\Starter\BlobManager"

#Create a new .NET project named BlobManager
dotnet new console --name BlobManager --output .
#Import version 12.0.0 of Azure.Storage.Blobs from NuGet
dotnet add package Azure.Storage.Blobs --version 12.0.0
#Build the webapp
dotnet build 

az group delete -n $Name -y