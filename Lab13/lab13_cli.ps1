

<#
Lab scenario
Your marketing organization has been tasked with building a website landing page to host content about an upcoming edX course. 
While designing the website, your team decided that multimedia videos and image content would be the ideal way to convey your marketing message. 
The website is already completed and available using a Docker container, and your team also decided that it would like to use a content delivery network (CDN)
to improve the performance of the images, the videos, and the website itself. You have been tasked with using Microsoft Azure Content Delivery Network to
improve the performance of both standard and streamed content on the website.

Objectives
After you complete this lab, you will be able to:
Register a Microsoft.CDN resource provider.
Create Content Delivery Network resources.
Create and configure Content Delivery Network endpoints that are bound to various Azure services.
#>
az account set -s "3f96110b-d3c2-4772-bd71-d11212d23f47"
$Name = "MarketingContent"
$location = 'EastUS'
$Suffix = 'awmc'
az group create -n $Name -l $location

#Create a storage account
#! Geo-Redundant storage
az storage account create -g $Name -l $location -n "contenthost$suffix" --kind StorageV2 --sku Standard_RAGRS --access-tier Hot 

# Task 3: Create a web app by using Azure App Service
az appservice plan create -g $Name -l $location -n MarketingPlan --sku P1V2
#! This silently failed to actually deploy the container image
az webapp create -g $Name -p MarketingPlan -n "landingpage$suffix" --deployment-container-image-name microsoftlearning/edx-html-landing-page:latest

# Task 2: Register the Microsoft.CDN provider
az provider list --query "[?namespace=='Microsoft.CDN']"
az provider register --namespace "Microsoft.CDN"

# Task 3: Create a Content Delivery Network profile
az cdn profile create -n contentdeliverynetwork -g $Name -l $location --sku Standard_Akamai

# Task 5: Create Content Delivery Network endpoints
az cdn endpoint create -g $Name -l $location -n "cdnmedia$suffix" --origin "contenthostawmc.blob.core.windows.net" --origin-path "/media" --profile-name contentdeliverynetwork --enable-compression true
az cdn endpoint create -g $Name -l $location -n "cdnvideo$suffix" --origin "contenthostawmc.blob.core.windows.net" --origin-path "/video" --profile-name contentdeliverynetwork --enable-compression true
az cdn endpoint create -g $Name -l $location -n "cdnweb$suffix" --origin "landingpageawmc.azurewebsites.net" --profile-name contentdeliverynetwork --enable-compression true 

# https://contenthostawmc.blob.core.windows.net/video
# https://contenthostawmc.blob.core.windows.net/media

# Exercise 4: Use Content Delivery Network endpoints
# https://cdnmediaawmc.azureedge.net
# https://cdnvideoawmc.azureedge.net
start "https://cdnmediaawmc.azureedge.net/conference.jpg"

az group delete -n $Name --no-wait --yes 