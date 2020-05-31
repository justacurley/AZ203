$root='D:\Dropbox\Source\AZ203'
#! EXERCISE 1
# Create Resource Group
$Name = 'ManagedPlatform'
$Location = 'EastUS'
$Suffix = 'awmc'
az group create -n $Name -l $Location

# Create a storage account
az storage account create --resource-group $Name --location $location --name "imgstor$suffix" --sku Standard_LRS --access-tier Hot --kind StorageV2
 # save connection string
 $scs = 'DefaultEndpointsProtocol=https;AccountName=imgstorawmc;AccountKey=YXwYJ9Cb+jxT8XzfagfNzTVPWu/MO+IXU6sYtheKWr8taOSgYuuqgTyVAdqSSmBR4richgpD9BOmMpMdDvFxXw==;EndpointSuffix=core.windows.net'

# Upload sample blobs to SA in /images container
# Create an app service plan for a web app
az appservice plan create --resource-group $Name --name ManagedPlan --sku S1
# Create a webapp on that plan
  # list az webapp runtimes
  az webapp list-runtimes
az webapp create --resource-group $Name --name "imgapi$Suffix" --plan ManagedPlan #--runtime "dotnetcore"
  # save new app setting
  az webapp config appsettings set --resource-group $Name -n "imgapi$Suffix" --settings StorageConnectionString=$scs
  #list our webapp
  az webapp list --resource-group $Name --query "[?starts_with(name, 'imgapi')]"
  az webapp list --resource-group $Name --query "[?starts_with(name, 'imgapi')].{Name:name}" --output tsv
# Deploy app to our webapp
sl $root\allfiles\Labs\01\Starter\API
az webapp deployment source config-zip --resource-group $Name --src api.zip --name "imgapi$Suffix"

#test
$Result=Invoke-RestMethod -URI "https://imgapi$Suffix.azurewebsites.net/" -Method Get 
$Result.GetType().Name -eq 'Object[]'
$Result[0] -match "grilledcheese"

#! EXERCISE 2
# Create a webapp to front end imgapi webapp created in exercise 1
az webapp create --resource-group $Name --name "imgweb$Suffix" --plan ManagedPlan 
az webapp config appsettings set --resource-group $Name -n "imgweb$Suffix" --settings ApiUrl="https://imgapi$Suffix.azurewebsites.net/"
# Deploy app to our webapp
sl $root\allfiles\labs\01\Starter\Web
az webapp deployment source config-zip --resource-group $Name --src web.zip --name "imgweb$Suffix"

# Clean up
az group delete --name $Name --no-wait --yes 