#!/bin/bash
set -e

# Start Nginx in the background
nginx

# Start the .NET application
dotnet ApiServer.dll
