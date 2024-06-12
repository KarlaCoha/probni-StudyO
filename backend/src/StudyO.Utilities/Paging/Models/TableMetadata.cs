namespace StudyO.Utilities.Paging.Models
{
    public class TableMetadata
    {
        public List<Filter>? Filter { get; set; }
        public List<Sort>? Sort { get; set; }
        public Page Page { get; set; } = null!;
    }
}
