using System.Text.Json;
using Microsoft.IdentityModel.Tokens;

namespace StudyO.Api.Middleware
{
    public class ExceptionMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ExceptionMiddleware> _logger;

        public ExceptionMiddleware(RequestDelegate next, ILogger<ExceptionMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task Invoke(HttpContext context)
        {
            try
            {
                if (!context.Request.Body.CanSeek)
                {
                    context.Request.EnableBuffering();
                }

                await _next(context);

            }
            catch (SecurityTokenExpiredException)
            {
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                await context.Response.WriteAsync(JsonSerializer.Serialize(new { message = "Access token expired" }));
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = StatusCodes.Status500InternalServerError;
                await LogError(context, ex);
            }

        }

        private async Task<string> GetResponseBodyText(HttpResponse response)
        {
            if (!response.Body.CanRead)
            {
                return string.Empty;
            }

            var text = string.Empty;
            try
            {
                response.Body.Seek(0, SeekOrigin.Begin);
                using var reader = new StreamReader(response.Body);
                text = await reader.ReadToEndAsync();
                response.Body.Seek(0, SeekOrigin.Begin);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while reading response body");
            }

            return text;
        }

        private async Task LogError(HttpContext context, Exception ex)
        {
            var responseBody = await GetResponseBodyText(context.Response);
            _logger.LogError(ex, responseBody);
        }
    }
}
