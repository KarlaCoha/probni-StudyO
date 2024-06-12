using Microsoft.Extensions.Options;
using StudyO.Domain.Models.Security;

namespace StudyO.Api.Middleware
{
    public class AccessMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly IOptions<AccessOptions> _options;

        public AccessMiddleware(RequestDelegate next, IOptions<AccessOptions> options)
        {
            _next = next;
            _options = options;
        }
        public async Task Invoke(HttpContext context)
        {
            var xApiKey = context.Request.Headers["X-Api-Key"].FirstOrDefault();
            var claimsPrincipal = context.User;
            var apiKeyUser = claimsPrincipal?.Claims.FirstOrDefault(c => c.Type == "XApiKeyUser");
            if (xApiKey != null && _options.Value.ApiKey == xApiKey ||
            (apiKeyUser != null && apiKeyUser.ToString() == xApiKey))
            {
                context.Items["XApiKey"] = xApiKey;
                context.Items["XApiKeyUser"] = apiKeyUser;
            }

            await _next(context);
        }
    }
}
