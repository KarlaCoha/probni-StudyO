using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudyO.Core.Infrastructure.CachingService
{
    public sealed class QueryCachingPipelineBehavior<TRequest, TResponse>
    where TRequest : ICachedQuery
    {
        private readonly ICachedService _cachedService;
        private readonly Func<TRequest, CancellationToken, Task<TResponse>> _handler;

        public QueryCachingPipelineBehavior(ICachedService cachedService, Func<TRequest, CancellationToken, Task<TResponse>> handler)
        {
            _cachedService = cachedService ?? throw new ArgumentNullException(nameof(cachedService));
            _handler = handler ?? throw new ArgumentNullException(nameof(handler));
        }

        public async Task<TResponse> Handle(TRequest request, CancellationToken cancellationToken)
        {
            return await _cachedService.GetOrCreateAsync(request.Key, _ => _handler(request, cancellationToken), request.Expiration, cancellationToken);
        }
    }
}
