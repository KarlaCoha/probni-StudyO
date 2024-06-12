FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["src/StudyO.Domain/StudyO.Domain.csproj", "StudyO.Domain/"]
COPY ["src/StudyO.Utilities/StudyO.Utilities.csproj", "StudyO.Utilities/"]
COPY ["src/StudyO.Api/StudyO.Api.csproj", "StudyO.Api/"]
COPY ["src/StudyO.Core/StudyO.Core.csproj", "StudyO.Core/"]
COPY ["src/StudyO.Persistence/StudyO.Persistence.csproj", "StudyO.Persistence/"]
RUN dotnet restore "StudyO.Api/StudyO.Api.csproj"
WORKDIR "/src/StudyO.Api"
COPY . .
RUN dotnet build "StudyO.Api.csproj" -c Release -o /app/build --self-contained false

FROM build AS publish
RUN dotnet publish "StudyO.Api.csproj" -c Release -o /app/publish --self-contained false --no-restore

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "StudyO.Api.dll"]