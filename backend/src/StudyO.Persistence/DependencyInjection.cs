using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Persistence.Main;
using StudyO.Persistence.Repositories.Main;

namespace StudyO.Persistence
{
    public static class DependencyInjection
    {
        public static void ExecuteDatabaseMigrations(this IServiceProvider provider) 
        {
            using var scope = provider.CreateScope();
            var services = scope.ServiceProvider;
            var context = services.GetRequiredService<ApplicationDbContext>();
            context.Database.Migrate();
         }

        public static IServiceCollection AddPersistence(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddDbContext<ApplicationDbContext>(options =>
            {
                options.UseNpgsql(configuration.GetSection("StudyODbSettings:ConnectionString").Value!);
            }, ServiceLifetime.Scoped);

            services.AddMainRepositories();

            return services;
        }

        private static void AddMainRepositories(this IServiceCollection services)
        {
            services.AddTransient<IAnswerRepository, AnswerRepository>();
            services.AddTransient<ILessonRepository, LessonRepository>();
            services.AddTransient<IQuestionRepository, QuestionRepository>();
            services.AddTransient<ISchoolClassRepository, SchoolClassRepository>();
            services.AddTransient<ISpecialNeedRepository, SpecialNeedRepository>();
            services.AddTransient<ISubjectRepository, SubjectRepository>();
            services.AddTransient<IUserRepository, UserRepository>();
            services.AddTransient<IAccountRepository, AccountRepository>();
            services.AddTransient<IFriendsRepository, FriendsRepository>();

        }

    }
}
