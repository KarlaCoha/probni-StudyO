using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.Features;
using StudyO.Domain.Interfaces.Jwt.Interfaces;

namespace StudyO.Api.Middleware
{
    public class JwtMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly IJwtUtils _jwtUtils;



        public JwtMiddleware(
        RequestDelegate next,
        IJwtUtils jwtUtils)
        {
            _next = next;
            _jwtUtils = jwtUtils;
        }



        public async Task InvokeAsync(HttpContext context)
        {
            var token = context.Request.Headers["Authorization"].FirstOrDefault()?.Split().Last();
            if (token != null
           && !(context.Features.Get<IEndpointFeature>()?.Endpoint?.Metadata.Any(m => m is AllowAnonymousAttribute)).GetValueOrDefault())
            {
                var userAccountId = _jwtUtils.ValidateJwtToken(token);

                if (userAccountId == null)
                {
                    throw new UnauthorizedAccessException();
                }

                context.Items["UserAccountId"] = userAccountId;

            }
            await _next(context);
        }
    }
}
