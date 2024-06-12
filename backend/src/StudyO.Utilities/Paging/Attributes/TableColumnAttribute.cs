namespace StudyO.Utilities.Paging.Attributes
{
    [AttributeUsage(AttributeTargets.Property)]
    public class TableColumnAttribute : Attribute
    {
        private readonly string _dbColumnName;
        private readonly string _alias;
        private readonly bool _sortable;
        private readonly bool _filter;

        public TableColumnAttribute(string alias, string? dbColumnName, bool sortable, bool filter)
        {
            _alias = alias;
            _dbColumnName = dbColumnName;
            _sortable = sortable;
            _filter = filter;
        }

        public string? Alias { get { return _alias; } }
        public string? ColumnName { get { return _dbColumnName; } }
        public bool Sortable { get { return _sortable; } }
        public bool Filter { get { return _filter; } }
    }
}
