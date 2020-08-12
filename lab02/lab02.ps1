$root='D:\Dropbox\Source\AZ203'
az account set -s "3f96110b-d3c2-4772-bd71-d11212d23f47"
#! EXERCISE 1
# Create Resource Group
$Name = 'Serverless'
$Location = 'EastUS'
$Suffix = 'awmc'

httprepl.exe https://funclogicawmc.azurewebsites.net/api/GetSettingInfo
