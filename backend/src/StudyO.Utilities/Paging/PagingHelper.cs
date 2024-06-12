using System.Linq.Expressions;
using Microsoft.EntityFrameworkCore;
using StudyO.Utilities.Extensions;
using StudyO.Utilities.Extensions.Helpers;
using StudyO.Utilities.Paging.Models;

namespace StudyO.Utilities.Paging
{
    public static class PagingHelper
    {
        /// <summary>
        /// Method which builds query for filtering, paging and sorting.
        /// </summary>
        /// <param name="dbSet">DbSet for entity we want to filter data</param>
        /// <param name="tableMetadata">Metadata that we use for retrieving and paging data</param>
        /// <returns></returns>
        public static IQueryable<T> CreateTableQuery<T>(DbSet<T> dbSet, TableMetadata? tableMetadata) where T : class
        {
            IQueryable<T>? query = dbSet;
            if (tableMetadata != null)
            {
                if (tableMetadata.Filter != null)
                {
                    foreach (Filter filterMetadata in tableMetadata.Filter)
                    {
                        if (filterMetadata != null)
                        {
                            Expression<Func<T, bool>> predicate = QueryBuilder.BuildExpression<T>("ToLower", "Contains", filterMetadata.Column, filterMetadata.Value);
                            query = query.Where(predicate);
                        }
                    }
                }

                if (tableMetadata.Sort != null)
                {
                    foreach (Sort sortColumn in tableMetadata.Sort)
                    {
                        IOrderedQueryable<T>? orderedQuery = query.CustomOrderBy(sortColumn.OrderBy!, sortColumn.OrderDirection);
                        if (orderedQuery != null)
                        {
                            query = orderedQuery;
                        }
                    }
                }

                if (tableMetadata.Page != null &&
                    tableMetadata.Filter == null ||
                    tableMetadata.Filter?.Count == 0)
                {
                    query = query.Skip(tableMetadata.Page.Offset).Take(tableMetadata.Page.PageSize!);
                }
            }

            return query!;
        }
    }
}
