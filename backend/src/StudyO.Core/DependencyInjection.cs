using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using StudyO.Core.Services.Main.Interfaces;
using StudyO.Core.Services.Main;
using StudyO.Core.Infrastructure.EmailService;
using StudyO.Core.Infrastructure.CachingService;

namespace StudyO.Core
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddApplicationCore(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddMainServices();

            return services;
        }

        private static void AddMainServices(this IServiceCollection services)
        {
            services.AddTransient<IAnswerService, AnswerService>();
            services.AddTransient<ILessonService, LessonService>();
            services.AddTransient<IQuestionService, QuestionService>();
            services.AddTransient<ISchoolClassService, SchoolClassService>();
            services.AddTransient<ISpecialNeedService, SpecialNeedService>();
            services.AddTransient<ISubjectService, SubjectService>();
            services.AddTransient<IUserService, UserService>();
            services.AddTransient<IAccountService, AccountService>();
            services.AddTransient<IFriendService, FriendService>();
            services.AddTransient<EmailSender, EmailSender>();
            services.AddHttpContextAccessor();
            services.AddTransient<IFriendService, FriendService>();
            //services.AddSingleton<ICachedService, CacheService>();
            services.AddMemoryCache();

        }

    }
}
