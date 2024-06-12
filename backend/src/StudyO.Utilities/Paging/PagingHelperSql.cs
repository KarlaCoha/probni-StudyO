using StudyO.Utilities.Paging.Attributes;
using StudyO.Utilities.Paging.Models;
using System.Text;

namespace StudyO.Utilities.Paging
{
    public static class PagingHelperSql
    {
        /// <summary>
        /// Method which builds query for filtering, paging and sorting.
        /// </summary>
        /// <param name="query">Parameter sent from client</param>
        /// <param name="tableMetadata">Metadata that we use for retrieving and paging data</param>
        /// <returns></returns>
        public static string CreateTableQuery(string query, TableMetadata? tableMetadata)
        {
            if (tableMetadata != null)
            {
                if (tableMetadata.Filter != null)
                {
                    query = query.Replace("@@FILTER", CreateFilterQuery(tableMetadata.Filter));
                }
                else
                    query = query.Replace("@@FILTER", "");

                query = query.Replace("@@SORT", CreateSortQuery(tableMetadata.Sort[0]));
                query = query.Replace("@@OFFSET", CreatePagingQuery(tableMetadata.Page));
            }
            else
            {
                query = query.Replace("@@FILTER", "").Replace("@@SORT", "").Replace("@@OFFSET", "");
            }

            return query;
        }

        /// <summary>
        /// Method which builds query for filtering, paging and sorting dto types
        /// </summary>
        /// <param name="query">Parameter sent from client</param>
        /// <param name="tableMetadata">Metadata that we use for retrieving and paging data</param>
        /// <returns></returns>
        public static string CreateTableQuery<T>(string query, TableMetadata? tableMetadata)
        {
            if (tableMetadata != null)
            {
                if (tableMetadata.Filter != null)
                {
                    var attributeDict = new Dictionary<string, TableColumnAttribute>();
                    var properties = typeof(T).GetProperties();
                    foreach (var prop in properties)
                    {
                        var attribute = prop.CustomAttributes.Where(c => c.AttributeType == typeof(TableColumnAttribute)).FirstOrDefault();
                        if (attribute != null)
                        {
                            attributeDict.Add(prop.Name, new TableColumnAttribute(attribute.ConstructorArguments[0].ToString(), attribute.ConstructorArguments[1].ToString(), true, true));
                        }
                    }

                    foreach (var filter in tableMetadata.Filter)
                    {
                        if (attributeDict.Any(x => x.Key == filter.Column))
                        {
                            filter.Column = $"{attributeDict[filter.Column].Alias}.{attributeDict[filter.Column].ColumnName}";
                        }
                    }
                    query = query.Replace("@@FILTER", CreateFilterQuery(tableMetadata.Filter));
                }
                else
                    query = query.Replace("@@FILTER", "");

                query = query.Replace("@@SORT", CreateSortQuery(tableMetadata.Sort[0]));
                query = query.Replace("@@OFFSET", CreatePagingQuery(tableMetadata.Page));
            }
            else
            {
                query = query.Replace("@@FILTER", "").Replace("@@SORT", "").Replace("@@OFFSET", "");
            }

            return query;
        }

        private static string? CreateFilterQuery(List<Filter>? filterMetadata)
        {
            if (filterMetadata != null)
            {
                var sb = new StringBuilder();
                for (var i = 0; i < filterMetadata.Count; i++)
                {
                    if (i == 0)
                    {
                        sb.AppendLine($"WHERE {filterMetadata[i].Column} LIKE '%{filterMetadata[i].Value}%'");
                    }
                    else
                    {
                        sb.AppendLine($"AND {filterMetadata[i].Column} LIKE '%{filterMetadata[i].Value}%'");
                    }
                }
                return sb.ToString();
            }
            return null;
        }
        private static string? CreateSortQuery(Sort? sortMetadata)
        {
            if (sortMetadata != null)
            {
                var sb = new StringBuilder();
                var sortData = sortMetadata;
                sb.AppendLine($"ORDER BY {sortData.OrderBy} {sortData.OrderDirection}");
                return sb.ToString();
            }
            return null;
        }
        private static string? CreatePagingQuery(Page? pagingMetadata)
        {
            if (pagingMetadata != null)
            {
                var sb = new StringBuilder();
                var pagedData = pagingMetadata;
                sb.AppendLine($"OFFSET {pagedData.Offset} ROWS");
                sb.AppendLine($"FETCH NEXT {pagedData.PageSize} ROWS ONLY");
                return sb.ToString();
            }
            return null;
        }
    }
}
