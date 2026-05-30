using Microsoft.AspNetCore.Http;

public class AuthMiddleware
{
    private readonly RequestDelegate _next;

    public AuthMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task Invoke(HttpContext context)
    {
        var path = context.Request.Path.ToString().ToLower();

        if (path.Contains("/booking") ||
            path.Contains("/payment") ||
            path.Contains("/refund"))
        {
            var role = context.Session.GetString("role");

            if (string.IsNullOrEmpty(role))
            {
                context.Response.Redirect("/Account/Login");
                return;
            }
        }

        await _next(context);
    }
}