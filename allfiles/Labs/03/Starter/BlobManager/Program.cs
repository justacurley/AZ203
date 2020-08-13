using Azure.Storage;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using System;
using System.Threading.Tasks;

namespace BlobManager
{
    public class Program
    {
        //create three constant strings
        private const string blobServiceEndpoint = "https://mediastorawmc.blob.core.windows.net/";
        private const string storageAccountName = "mediastorawmc";
        private const string storageAccountKey = "AM/p1oG8NTAUfW/X4Nnqpd0goEa7gREuOYYfygkuUaUPdu3NIzXbft5SzmlrYUzZXglpyBX81VDEQ0M3vV9JKA==";
        
        //Create an asynchronous Main entry point method
        public static async Task Main(string[] args)
        {
            //create credential object
            StorageSharedKeyCredential accountCredentials = new StorageSharedKeyCredential(storageAccountName, storageAccountKey);
            //connect to storage account
            BlobServiceClient serviceClient = new BlobServiceClient(new Uri(blobServiceEndpoint), accountCredentials);
            //retrieve SA metadata
            AccountInfo info = await serviceClient.GetAccountInfoAsync();

            await Console.Out.WriteLineAsync($"Connected to Azure Storage Account");
            await Console.Out.WriteLineAsync($"Account name:\t{storageAccountName}");
            await Console.Out.WriteLineAsync($"Account kind:\t{info?.AccountKind}");
            await Console.Out.WriteLineAsync($"Account sku:\t{info?.SkuName}");

            //Call method defined below
            await EnumerateContainersAsync(serviceClient);

            string existingContainerName = "raster-graphics";
            await EnumerateBlobsAsync(serviceClient, existingContainerName);

            string newContainerName = "vector-graphics";
            BlobContainerClient containerClient = await GetContainersAsync(serviceClient, newContainerName);

            string uploadedBlobName = "graph.svg";
            BlobClient blobClient = await GetBlobAsync(containerClient, uploadedBlobName);
            await Console.Out.WriteLineAsync($"Blob Uril:\t{blobClient.Uri}");
            
        }

        //Create a new static method named EnumerateContainersAsync with a single BlobServiceClient parameter
        private static async Task EnumerateContainersAsync(BlobServiceClient client)
        {
            //loop over all containers and print out the name
            await foreach (BlobContainerItem container in client.GetBlobContainersAsync())
            {
                await Console.Out.WriteLineAsync($"Contains:\t{container.Name}");
            }
        }
        //enumerate blobs in container
        private static async Task EnumerateBlobsAsync(BlobServiceClient client, string containerName)
        {
            //get a new instance of the BlobContainerClient class by using the GetBlobContainerClient method of the BlobServiceClient class, passing in the containerName parameter
            BlobContainerClient container = client.GetBlobContainerClient(containerName);
            //print name of container that will be enumerated
            await Console.Out.WriteLineAsync($"Searching:\t{container.Name}");
            await foreach (BlobItem blob in container.GetBlobsAsync())
            {
                await Console.Out.WriteLineAsync($"Existing Blob:\t{blob.Name}");
            }
        }
        //Create new container
        private static async Task<BlobContainerClient> GetContainersAsync(BlobServiceClient client, string containerName)
        {
            BlobContainerClient container = client.GetBlobContainerClient(containerName);
            await container.CreateIfNotExistsAsync(PublicAccessType.Blob);
            await Console.Out.WriteLineAsync($"New Container:\t{container.Name}");
            return container;
        }
        //Access blob URI
        private static async Task<BlobClient> GetBlobAsync(BlobContainerClient client, string blobName)
        {
            BlobClient blob = client.GetBlobClient(blobName);
            await Console.Out.WriteLineAsync($"Blob Found:\t{blob.Name}");
            return blob;
        }
    }
}
