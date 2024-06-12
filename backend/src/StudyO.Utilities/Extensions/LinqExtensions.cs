using System.Linq.Expressions;
using System.Reflection;

namespace StudyO.Utilities.Extensions
{
    public static class LinqExtensions
    {
        /* https://github.com/dotnet/efcore/issues/19087 */
        public static IOrderedQueryable<TSource> CustomOrderBy<TSource>(this IQueryable<TSource> query, string propertyName, string orderDirection)
        {
            var orderingMethod = orderDirection.ToLower() == "desc" ? "OrderByDescending" : "OrderBy";
            var invokedMethod = CreateOrderedQueryable(query, propertyName, orderingMethod);
            return invokedMethod;
        }

        private static IOrderedQueryable<TSource> CreateOrderedQueryable<TSource>(IQueryable<TSource> query, string propertyName, string methodName)
        {
            var entityType = typeof(TSource);

            var propertyInfo = entityType.GetProperty(propertyName);
            if (propertyInfo.DeclaringType != entityType)
            {
                propertyInfo = propertyInfo.DeclaringType.GetProperty(propertyName);
            }

            if (propertyInfo == null)
            {
                return (IOrderedQueryable<TSource>)query;
            }

            var arg = Expression.Parameter(entityType, "x");
            var property = Expression.MakeMemberAccess(arg, propertyInfo);
            var selector = Expression.Lambda(property, new ParameterExpression[] { arg });

            var method = typeof(Queryable).GetMethods()
                 .Where(m => m.Name == methodName && m.IsGenericMethodDefinition)
                 .First(m => m.GetParameters().ToList().Count == 2);

            var genericMethod = method.MakeGenericMethod(entityType, propertyInfo.PropertyType);

            return (IOrderedQueryable<TSource>)genericMethod.Invoke(genericMethod, new object[] { query, selector });
        }
    }
}
