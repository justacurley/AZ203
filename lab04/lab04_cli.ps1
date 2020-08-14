az account set -s "3f96110b-d3c2-4772-bd71-d11212d23f47"
$Name = "PolyglotData"
$Location = "EastUS"
$Suffix = "awmc"
az group create -n $Name -l $Location

#Create an Azure SQL Database server resource
az sql server create -g $Name -l $Location -n "polysqlserver$Suffix" -u testuser -p TestPa55w.rd 
$connectionString = 'Server=tcp:polysqlserverawmc.database.windows.net,1433;Initial Catalog=AdventureWorks;Persist Security Info=False;User ID=testuser;Password=TestPa55w.rd;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'

#Create an Azure Cosmos DB instance
az cosmosdb create -g $Name -n "polycosmos$Suffix" --enable-free-tier false 

#Create a storage account
az storage account create -g $Name -l $Location -n "polystor$Suffix" --sku Standard_LRS --kind StorageV2 --access-tier Hot
$containerUri = 'https://polystorawmc.blob.core.windows.net/images'

Set-Location -Path "D:\Dropbox\Source\AZ203\allfiles\Labs\04\Starter\AdventureWorks"

dotnet build

Set-Location -Path AdventureWorks.Web
$connectionString | clip 
psedit appsettings.json
$containerUri | clip
psedit appsettings.json

dotnet run
start "http:\\localhost:5000"

#Create a new dotnet project
Set-Location -Path ..
dotnet new console --name AdventureWorks.Migrate
#Add a reference to existing projects in AdventureWorks.Migrate
dotnet add .\AdventureWorks.Migrate\AdventureWorks.Migrate.csproj reference .\AdventureWorks.Models\AdventureWorks.Models.csproj
dotnet add .\AdventureWorks.Migrate\AdventureWorks.Migrate.csproj reference .\AdventureWorks.Context\AdventureWorks.Context.csproj
Set-Location -Path .\AdventureWorks.Migrate\
#Import packages from nuget
dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 3.0.1
dotnet add package Microsoft.Azure.Cosmos --version 3.4.1

dotnet build

psedit .\Program.cs

#Access cosmos db using .net
Set-Location ..\AdventureWorks.Context
#add cosmos package
dotnet add package Microsoft.Azure.Cosmos --version 3.4.1
dotnet build
New-Item .\AdventureWorksCosmosContext.cs
psedit .\AdventureWorksCosmosContext.cs
$cosmostConnectionString = "AccountEndpoint=https://polycosmosawmc.documents.azure.com:443/;AccountKey=tP1E94SOFpex5zRF8oFupos58BckdtRKPWxp4hr1whJ7MyowDwnwOd5mfOpE9MZMpnk8poKHOJ84vx5VAjxsVA==;"
$cosmostConnectionString | clip
psedit ..\AdventureWorks.Web\appsettings.json
Set-Location ..\AdventureWorks.Web
psedit startup.cs
# az group delete -n $Name -y --no-wait