using System.Linq.Expressions;

namespace StudyO.Utilities.Extensions.Helpers
{
    internal class QueryBuilder
    {
        public static Expression<Func<T, bool>> BuildExpression<T>(string property, string constant)
        {
            var expressionParameter = Expression.Parameter(typeof(T));
            var expressionProperty = Expression.Property(expressionParameter, property);
            var expressionConstant = Expression.Constant(constant, typeof(string));
            var expression = Expression.Equal(expressionProperty, expressionConstant);

            return Expression.Lambda<Func<T, bool>>(expression, expressionParameter);
        }

        public static Expression<Func<T, bool>> BuildExpression<T>(string methodNameLeft, string methodNameRight, string property, string constant)
        {
            var expressionMethodLeft = typeof(string).GetMethods().FirstOrDefault(x => x.Name == methodNameLeft);
            var expressionMethodRight = typeof(string).GetMethods().FirstOrDefault(x => x.Name == methodNameRight);

            var expressionParameter = Expression.Parameter(typeof(T), "x");
            var expressionProperty = Expression.Property(expressionParameter, property);
            var expressionConstant = Expression.Constant(constant, typeof(string));

            var expressionLeft = Expression.Call(expressionProperty, expressionMethodLeft);
            var expressionRight = Expression.Call(expressionLeft, expressionMethodRight, expressionConstant);

            return Expression.Lambda<Func<T, bool>>(expressionRight, expressionParameter);
        }
    }
}
