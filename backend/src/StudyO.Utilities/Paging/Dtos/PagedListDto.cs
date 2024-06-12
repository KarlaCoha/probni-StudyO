using StudyO.Utilities.Paging.Models;
using System.Text.Json.Serialization;

namespace StudyO.Utilities.Paging.Dtos
{
    public record PagedListDto<T>
    {
        public IEnumerable<T> Data { get; set; } = new List<T>();
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public Page? Page { get; set; } = default;
    }
}
