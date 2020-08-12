using Microsoft.AspNetCore.Mvc;
using System.Net;

//create a new public static method name 'Run' that returns a variable of type IActionResult
//Parameters of type HttpRequest and string
public static IActionResult run(HttpRequest req, string json)
{
    //return the content of the json parameter
    return new OkObjectResult(json);
}