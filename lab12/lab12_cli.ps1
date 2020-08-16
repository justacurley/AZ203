<#
Lab scenario
You have created an API for your next big startup venture. 
Even though you want to get to market quickly, you have witnessed other ventures fail when they don’t plan for growth and have too few resources or too many users. 
To plan for this, you have decided to take advantage of the scale-out features of Microsoft Azure App Service, the telemetry features of Application Insights, 
and the performance-testing features of Azure DevOps.

Objectives
After you complete this lab, you will be able to:
Create an Application Insights resource.
Integrate Application Insights telemetry tracking into an ASP.NET web app and a resource built using the Web Apps feature of Azure App Service.
#>


az account set -s "3f96110b-d3c2-4772-bd71-d11212d23f47"
$Name = "MonitoredAssets"
$location = 'EastUS'
$Suffix = 'awmc'
az group create -n $Name -l $location

# Task 2: Create an Application Insights resource
# There is no extension for app insights in az cli yet.

# Task 3: Create a web app by using Azure App Services resource
az appservice plan create -g $Name -l $location -n "MonitoredPlan" --sku S1 
az webapp create -g $Name -n "smpapi$suffix" -plan "MonitoredPlan" -r 'DOTNETCORE|3.1'
#Enable app insights monitoring from portal


Set-Location D:\Dropbox\Source\AZ203\allfiles\labs\12\Starter\Api
dotnet new webapi -n SimpleApi -o . 
dotnet add package Microsoft.ApplicationInsights -v 2.13.0
dotnet add package Microsoft.ApplicationInsights.AspNetCore -v 2.13.0
dotnet add package Microsoft.ApplicationInsights.PerfCounterCollector -v 2.13.0
dotnet build

#Task 1: Deploy an application to the web app
$webappName = az webapp list -g $Name --query "[?starts_with(name, 'smpapi')].{Name:name}" -o tsv
Set-Location ..\ 
az webapp deployment source config-zip -g $Name --src .\api.zip --name $webappName
start https://smpapiawmc.azurewebsites.net/weatherforecast
az group delete -n $Name --no-wait --yes 