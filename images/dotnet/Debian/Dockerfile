# Use the official ASP.NET Core runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Set an environment variable for the application name
ENV APP_NAME=code

# Copy csproj and restore as distinct layers
COPY ../code/*.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY ../code/ .
RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

FROM base AS final
WORKDIR /app

# Create a group and a non root user
RUN groupadd -r limitedaccessuser && useradd -r -g limitedaccessuser -d /app -s /sbin/nologin limitedaccessuser

# Set an environment variable for the application name
ENV APP_NAME=code

# Copy the entrypoint script and make it executable
COPY ../Debian/entrypoint.sh /app/entrypoint.sh

COPY ../code/bin/Debug/net8.0/$APP_NAME.dll app/

RUN chmod +x /app/entrypoint.sh

# Copy the published application into the image
COPY --from=publish /app/publish .

# Change the ownership of the application files to the new user and group
RUN chown -R limitedaccessuser:limitedaccessuser /app

# Switch to the non root user
USER limitedaccessuser

# Use the entrypoint script as the entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
