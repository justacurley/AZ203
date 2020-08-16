# Register Microsoft.EventGrid Provider
az provider Register --namespace 'Microsoft.EventGrid' --wait
# Create an rg
az group create -n 'PubSubEvents' -l 'EastUs'
# Create a custom eventgrid topic
az eventgrid topic create -n hrtopicawmc -g PubSubEvents -l 'EastUS'
#Create a Web App
az appservice plan create -g PubSubEvents -n myPlan --sku P1V2
az webapp create -g PubSubEvents -n eventviewerawmc --plan myPlan --deployment-container-image-name microsoftlearning/azure-event-grid-viewer:latest
#eventviewerawmc.azurewebsites.net

# Create eventgrid subscription
az eventgrid event-subscription create --endpoint 'https://eventviewerawmc.azurewebsites.net/api/updates' --name basicsub --endpoint-type webhook 
