FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY ["MyAksApp.csproj", "./"]
RUN dotnet restore "MyAksApp.csproj"

# Copy all files and build
COPY . .
RUN dotnet build "MyAksApp.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "MyAksApp.csproj" -c Release -o /app/publish

# Create the final image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "MyAksApp.dll"]