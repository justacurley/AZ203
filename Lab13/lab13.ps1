#create a resource group

az group create -n MarketingContent -l 'EastUS'
az group list


# Create a storage account
az storage account create -n contenthostawmc -g MarketingContent --location EastUS --kind StorageV2 --sku Standard_RAGRS --access-tier Hot

# Create a appservice plan
az appservice plan create -g MarketingContent --name myPlan --sku P1V2
# Create a web app
 #list runtimes available
 az webapp list-runtimes
az webapp create -g MarketingContent -n landingpageawmc --plan myPlan --deployment-container-image-name microsoftlearning/edx-html-landing-page:latest
 #get the uri of the webapp
  az webapp show -g MarketingContent -n landingpageawmc --query 'defaultHostName' -o json
  #"landingpageawmc.azurewebsites.net"

# Register Microsoft.CDN provider in subscription
az provider list --query "[].namespaces"
az provider register -n 'Microsoft.CDN' --wait 

# Create CDN profile
az cdn profile create -g MarketingContent -n contentdeliverynetwork -l EastUs --sku Standard_Akamai

# Configure storage containers
 #completed through portal

# Create CDN endpoints
# az cdn endpoint create -g MarketingContent -n cdnmediaawmc --origin contenthostawmc.blob.core.windows.net --origin-path '/media' --profile-name contentdeliverynetwork
 #deleteand start over, this one has a lot of settings
#  az cdn endpoint delete -g marketingcontent -n cndmediaawmc --profile-name contentdeliverynetwork
# /MEDIA
az cdn endpoint create -g marketingcontent -n cdnmediaawmc --origin contenthostawmc.blob.core.windows.net --origin-path '/media' --profile-name contentdeliverynetwork  --enable-compression true -l EastUs
# /VIDEO
az cdn endpoint create -g marketingcontent -n cdnmvideoawmc --origin contenthostawmc.blob.core.windows.net --origin-path '/video' --profile-name contentdeliverynetwork  --enable-compression true -l EastUs
#update with optimzation type, which az cli does not currently support i guess
install-module az.cdn -force
$prof=Get-AzCDNProfile -ProfileName contentdeliverynetwork -ResourceGroupName marketingcontent
$endpoint = Get-AzCDNEndpoint -CDNProfile $prof -EndpointName cdnmvideoawmc
$endpoint.OptimizationType = 'GeneralWebDelivery'
$endpoint | Set-AzCDNEndpoint
$endpoint = Get-AzCDNEndpoint -CDNProfile $prof -EndpointName cdnmediaawmc
$endpoint.OptimizationType = 'VideoOnDemandMediaStreaming'
$endpoint | Set-AzCDNEndpoint

# WebApp
az cdn endpoint create -g marketingcontent -n cdnwebawmc --origin "landingpageawmc.azurewebsites.net" --profile-name contentdeliverynetwork  --enable-compression true -l EastUs
$endpoint = Get-AzCDNEndpoint -CDNProfile $prof -EndpointName cdnwebawmc
$endpoint.OptimizationType = 'GeneralWebDelivery'
$endpoint | Set-AzCDNEndpoint

# Upload content to /MEDIA and /VIDEO containers (done in portal)
# https://contenthostawmc.blob.core.windows.net/video/welcome.mp4
# https://contenthostawmc.blob.core.windows.net/media/campus.jpg

# Configure webapp settings
az webapp config appsettings set -g marketingcontent -n landingpageawmc --settings CDNMediaEndpoint=https://contenthostawmc.blob.core.windows.net/media
az webapp config appsettings set -g marketingcontent -n landingpageawmc --settings CDNVideoEndpoint=https://contenthostawmc.blob.core.windows.net/video

# Restart the webapp
az webapp restart -g marketingcontent -n landingpageawmc