using System.Net;
using Microsoft.AspNetCore.Mvc;
    
public static async Task<IActionResult> Run(HttpRequest req)
{
    string connectionString = Environment.GetEnvironmentVariable("StorageConnectionString");
    return new OkObjectResult(connectionString);
}