<#

The developers in your company have successfully adopted and used the https://httpbin.org/ website to test various clients that issue HTTP requests. 
Your company would like to use one of the publicly available containers on Docker Hub to host the httpbin web application in an enterprise-managed environment with a few caveats. 
First, developers who are issuing Representational State Transfer (REST) queries should receive standard headers that are used throughout the company’s applications. 
Second, developers should be able to get responses by using JavaScript Object Notation (JSON) even if the API that’s used behind the scenes doesn’t support the data format. 
You’re tasked with using Microsoft Azure API Management to create a proxy tier in front of the httpbin web application to implement your company’s policies.

Create a web application from a Docker Hub container image.
Create an API Management account.
Configure an API as a proxy for another Azure service with header and payload manipulation.

#>
az account set -s "3f96110b-d3c2-4772-bd71-d11212d23f47"
$Name = "ApiService"
$location = 'EastUS'
$Suffix = 'awmc'

az group create -n  $Name -l $location

az appservice plan create -g $Name -l $location -n myPlan --sku P1V2 --is-linux


# az group delete -n $Name --no-wait --yes