using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudyO.Core.Infrastructure.CachingService
{
    public interface ICachedQuery
    {
        public string Key { get; set; }
        public TimeSpan? Expiration { get; set; }
    }

    public interface ICachedQuery<TResponse> : ICachedQuery
    {
    }
}
