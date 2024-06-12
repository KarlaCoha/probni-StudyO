using Azure.Identity;
using Microsoft.ApplicationInsights;
using Microsoft.OpenApi.Models;
using StudyO.Api.Middleware;
using StudyO.Core;
using StudyO.Core.Services.Main;
using StudyO.Domain.Models.Security;
using StudyO.Persistence;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

builder.Services.Configure<AccessOptions>(opt => builder.Configuration.Bind(nameof(AccessOptions), opt));

builder.Services.AddPersistence(builder.Configuration);
builder.Services.AddApplicationCore(builder.Configuration);
builder.Services.AddApplicationInsightsTelemetry();

builder.Configuration.AddAzureKeyVault(
    new Uri("https://akv-studyo.vault.azure.net/"),
    new DefaultAzureCredential(new DefaultAzureCredentialOptions()
    {
        ExcludeVisualStudioCredential = true,
        ExcludeVisualStudioCodeCredential = true
    }));


builder.Services.AddControllers()
    .AddNewtonsoftJson(options =>
    {
        options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
        options.SerializerSettings.NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore;
    });
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "StudyO API", Version = "v1", Description = "" });
    #region Security definitions
    c.AddSecurityDefinition("ApiKey", new OpenApiSecurityScheme()
    {
        Type = SecuritySchemeType.ApiKey,
        In = ParameterLocation.Header,
        Name = "X-Api-Key",
        Description = "Specify API key",
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
        {
            {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "ApiKey" }
            },
            Array.Empty<string>()
            }
        });
    #endregion
});

builder.Services.AddSingleton<NotificationService>();


builder.Services.AddRouting(options => options.LowercaseUrls = true);


WebApplication app = builder.Build();

app.Use(async (context, next) =>
{
    try
    {
        await next.Invoke();
    }
    catch (Exception ex)
    {
        var telemetryClient = app.Services.GetRequiredService<TelemetryClient>();
        telemetryClient.TrackException(ex);
        throw;
    }
});

app.UseMiddleware<AccessMiddleware>();
app.UseMiddleware<ExceptionMiddleware>();
app.UseMiddleware<HttpSecurityMiddleware>();

app.UseSwagger();
app.UseSwaggerUI(config =>
{
    config.SwaggerEndpoint("/swagger/v1/swagger.json", "StudyO API");
});

app.UseHttpsRedirection();
app.UseHsts();
app.UseCookiePolicy();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Services.ExecuteDatabaseMigrations();


app.Run();
