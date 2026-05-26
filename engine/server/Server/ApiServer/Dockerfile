FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /src

# Copy csproj/shproj and restore as distinct layers to leverage Docker cache
COPY ["Server/ApiServer/ApiServer.csproj", "Server/ApiServer/"]
COPY ["Server/Server/Server.csproj", "Server/Server/"]
COPY ["Server/FlatBuffers/Google.FlatBuffers.csproj", "Server/FlatBuffers/"]
COPY ["Server/Google.Protobuf/Google.Protobuf.csproj", "Server/Google.Protobuf/"]
COPY ["Server/Commons/Commons.shproj", "Server/Commons/"]
COPY ["Server/Commons/Commons.projitems", "Server/Commons/"]
COPY ["Server/global.json", "Server/"]

# Restore dependencies for the main project
RUN dotnet restore "Server/ApiServer/ApiServer.csproj"

# Copy the rest of the source code needed for the build
COPY Server/. ./Server/

# Publish the application
WORKDIR "/src/Server/ApiServer"
RUN dotnet publish "ApiServer.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Create the final image with Nginx and the .NET runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
# Install Nginx
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# Remove default Nginx config
RUN rm -f /etc/nginx/conf.d/default.conf

# Set environment variable for Kestrel to listen on port 5000
ENV ASPNETCORE_URLS="http://+:5000"

WORKDIR /app
 # Nginx will listen on port 80
 EXPOSE 80

# Copy the Nginx configuration
COPY Server/ApiServer/nginx.conf /etc/nginx/conf.d/default.conf

# Copy the published .NET application files from the build-env stage
COPY --from=build-env /app/publish .

# Copy the custom entrypoint script
COPY Server/ApiServer/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
