<#
Lab scenario
You’re studying various ways to communicate between isolated service components in Microsoft Azure, and you have decided to evaluate the Azure Storage service and its Queue service offering.
As part of this evaluation, you’ll build a prototype application in .NET that can send and receive messages so that you can measure the complexity involved in using this service. 
To help you with your evaluation, you’ve also decided to use Azure Storage Explorer as the queue message producer/consumer throughout your tests.

Objectives
After you complete this lab, you will be able to:
Add Azure.Storage libraries from NuGet.
Create a queue in .NET.
Produce a new message in the queue by using .NET.
Consume a message from the queue by using .NET.
Manage a queue by using Storage Explorer.
#>

az account set -s "3f96110b-d3c2-4772-bd71-d11212d23f47"
$Name = "AsyncProcessor"
$location = 'EastUS'
$Suffix = 'awmc'
az group create -n $Name -l $location

# Task 2: Create a Storage account
az storage account create -g $name -l $location -n "asyncstor$suffix" --kind StorageV2 --sku Standard_LRS --access-tier Hot
#Get connection string and access key
$connectionString = az storage account show-connection-string -g $name -n "asyncstor$suffix" --query "connectionString" -o tsv
$key=az storage account keys list -g $name -n "asyncstor$suffix" --query "[0].value" -o tsv

Set-Location "D:\Dropbox\Source\AZ203\allfiles\Labs\11\Starter\MessageProcessor"
dotnet new console -n "MessageProcessor" -o .
dotnet add package Azure.Storage.Queues -v 12.0.0
dotnet build
psedit program.cs


az group delete -n $Name --no-wait --yes