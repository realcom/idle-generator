@echo off
cd /d "%~dp0"

for /r %%f in (*.cs) do (
    echo "Running generator: %%f"
    dotnet run "%%f"
)