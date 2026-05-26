@echo off
chcp 65001 >nul

echo Start Build.bat

call Commons\Build.bat

echo 👌 Complete Build.bat

echo Start sever specified Build

cd /d "%~dp0"
dotnet run Generators\WorldServer.WorldPlayer.Handler.Request.Generator.cs
dotnet run Generators\WorldServer.WorldPlayer.Handler.Update.Generator.cs

echo 👌👌👌👌👌👌 Finish Build