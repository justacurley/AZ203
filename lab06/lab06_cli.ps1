az account set -s "3f96110b-d3c2-4772-bd71-d11212d23f47"
#Create an azad app registration in the portal
<#
Application (client) ID
:
262056a6-7c29-49ab-8e20-f4e4a6a53ce1
Directory (tenant) ID
:
fe5dbd37-1c53-41ac-86f0-49927eeb2caf
#>
$appID = '262056a6-7c29-49ab-8e20-f4e4a6a53ce1'
#Obtain a token by using the MSAL.NET library
Set-Location ..\allfiles\labs\06\starter\graphclient
#create a new project
dotnet new console -n GraphClient -o .
#Add microsoft identity client package to the project
dotnet add package Microsoft.Identity.Client --version 4.7.1
dotnet build
psedit program.cs

#Query MS Graph 
#import graph sdk
dotnet add package Microsoft.Graph --version 1.21.0
dotnet add package Microsoft.Graph.Auth -v 1.0.0-preview.2
dotnet build 
psedit program.cs

az ad app delete --id $appID