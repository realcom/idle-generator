FROM mcr.microsoft.com/dotnet/aspnet:8.0-noble-arm64v8 AS base
WORKDIR /app

COPY Server/output/* /app

ENTRYPOINT ["dotnet", "WorldServer.dll"]
