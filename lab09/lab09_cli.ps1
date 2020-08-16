<#
Lab scenario
Your organization keeps a collection of JSON files that it uses to configure third-party products in a Server Message Block (SMB) file share in Microsoft Azure. 
As part of a regular auditing practice, the operations team would like to call a simple HTTP endpoint and retrieve the current list of configuration files. 
You have decided to implement this functionality using a no-code solution based on Azure API Management service and Logic Apps.

Objectives
After you complete this lab, you will be able to:
Create a Logic App workflow.
Manage products and APIs in a Logic App.
Use Azure API Management as a proxy for a Logic App.
#>
az account set -s "3f96110b-d3c2-4772-bd71-d11212d23f47"
$Name = "AutomatedWorkflow"
$location = 'EastUS'
$Suffix = 'awmc'
az group create -n $Name -l $location

#Create an API Mgmt resource 
    #portal
#Task 3: Create a Logic App resource
#! Install logic apps extension
az extension add --name logic
#Create the rest from portal, i'm guessing this wont be on the exam as the logic extension is expiramental 

# Task 4: Create a storage account
az storage account create -g $Name -l $location -n "prodstor$Suffix" --kind StorageV2 --access-tier Hot --sku Standard_LRS


httprepl.exe https://prodapimawmc.azure-api.net/manual/paths/invoke

az group delete -n $Name --no-wait --yes 