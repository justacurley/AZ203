<#
Create an Azure key vault and store secrets in the key vault.
Create a system-assigned managed identity for an Azure App Service instance.
Create a Key Vault access policy for an Azure Active Directory identity or application.
Use the Storage .NET SDK to download a blob.
#>
az account set -s "3f96110b-d3c2-4772-bd71-d11212d23f47"
$Name = "SecureFunction"
$Location = "EastUS"
$Suffix = "awmc"
$uniqueVaultName = "mysecurevault953$suffix"
az group create -n $Name -l $Location

az storage account create -g $Name -n "securestor$suffix" -l $Location --kind StorageV2 --access-tier Hot --sku Standard_LRS
$storagecredentials = 'DefaultEndpointsProtocol=https;AccountName=securestorawmc;AccountKey=dLnHxVR+9+URk3aaIfUgV20FNo4U0pvVL8B4uI+qnA3V/1ytD8uqYEeeTfXvfI9hUovHcbrqRTWAJ07v1QBddQ==;EndpointSuffix=core.windows.net'

#Create a keyvault
az keyvault create -g $Name -n $uniqueVaultName -l $Location --enable-soft-delete false --sku standard
#Create storage credentials secret
az keyvault secret set --vault-name $uniqueVaultName --name storagecredentials --value $storagecredentials
$secretID = "https://mysecurevault953awmc.vault.azure.net/secrets/storagecredentials/962b257ad0fd4c5590264522bc8f1993"


#create a function app
az functionapp create -g $Name -n "securefunc$Suffix" --storage-account "securestor$suffix" --functions-version 3 --consumption-plan-location $Location
#assign managed identity for functionapp
az functionapp identity assign -g $name -n "securefunc$Suffix"
#Get the managed identity object id
$mid = az functionapp identity show -g $name --name "securefunc$Suffix" --query 'principalId' -o tsv
#Get the service principal name for the mid
$spn  = az ad sp show --id $mid --query 'servicePrincipalNames[0]'
#Create an access policy for the managed identity on the keyvault
az keyvault set-policy -g $Name --name $uniqueVaultName --secret-permissions get --spn $spn


az group delete -n $Name --no-wait --yes