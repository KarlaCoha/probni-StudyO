using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudyO.Core.Infrastructure.CachingService
{
    public interface ICachedService
    {
        Task<T> GetOrCreateAsync<T>(
            string key,
            Func<CancellationToken, Task<T>> factory,
            TimeSpan? expiration = null,
            CancellationToken cancellationToken = default);

    }
}
