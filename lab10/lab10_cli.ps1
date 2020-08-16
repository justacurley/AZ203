<#
Lab scenario
Your company builds a human resources (HR) system used by various customers around the world. 
While the system works fine today, your development managers have decided to begin re-architecting the solution by decoupling application components. 
This decision was driven by a desire to make any future development simpler through modularity. 
As the developer who manages component communication, you have decided to introduce Microsoft Azure Event Grid as your solution-wide messaging platform.

Objectives
After you complete this lab, you will be able to:
Create an Event Grid topic.
Use the Azure Event Grid viewer to subscribe to a topic and illustrate published messages.
Publish a message from a .NET application.
#>
az account set -s "3f96110b-d3c2-4772-bd71-d11212d23f47"
$Name = "PubSubEvents"
$location = 'EastUS'
$Suffix = 'awmc'
az group create -n $Name -l $location
az provider Register --namespace 'Microsoft.EventGrid' --wait

#Task 4: Create a custom Event Grid topic
az EventGrid topic create -g $Name -l $location -n "hrtopic$Suffix" --input-scheme eventgridschema

# Task 5: Deploy the Azure Event Grid viewer to a web app
az appservice plan create -g $Name -l $location -n EventPlan --sku P1V2 --is-linux
#!No location param, i think because we're using the app service plan location
az webapp create -g $Name -n "eventviewer$suffix" --plan EventPlan --deployment-container-image-name microsoftlearning/azure-event-grid-viewer:latest
$hostname = az webapp show -g $Name -n "eventviewer$suffix" --query "hostNames[0]" -o tsv
# Exercise 2: Create an Event Grid subscription
# Task 2: Create new subscription
#!The source should be the EventGrid Topic resourceID
$subSource=az eventgrid topic show -g $name -n "hrtopic$Suffix" --query "id" -o tsv
az eventgrid event-subscription create -n basicsub --event-delivery-schema eventgridschema --endpoint-type webhook --endpoint "https://$hostname/api/updates" --source-resource-id $subSource
# Task 4: Record subscription credentials
$TopicEndpoint = az eventgrid topic show -g $name -n "hrtopic$Suffix" --query "endpoint" -o tsv
$accessKey = 'PT1bkyElUR+2/mUesJo5DbDfLDhNtUsjsckVR8gkGJo='

# Exercise 3: Publish Event Grid events from .NET
Set-Location "D:\Dropbox\Source\AZ203\allfiles\Labs\10\Starter\EventPublisher"
dotnet new console -n EventPublisher -o .
dotnet add package -n Microsoft.Azure.EventGrid -v 3.2.0
dotnet build 
psedit Program.cs

az group delete -n $Name --no-wait --yes