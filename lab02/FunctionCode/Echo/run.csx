using Microsoft.ASPNetCore.Mvc;
using System.Net;

//create a public static method name 'Run' that returns a variable of type IActionResult
//Parameters are of type HTTPRequest and ILogger
public static IActionResult Run(HttpRequest req,  ILogger log)
{
    //Log a message
    log.LogInformation("Received a request");
    //echo the body of the request as an HTTP response
    return new OkObjectResult(req.Body);
}