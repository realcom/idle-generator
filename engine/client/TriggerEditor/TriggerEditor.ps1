# Set application path
$appPath = "./editor"

# Function to check if Node.js and npm are installed
function Check-NodeInstalled {
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-Host "Node.js is not installed. Opening the download page..."
        Start-Process "https://nodejs.org/en/download/prebuilt-installer/current"
        exit 1
    }

    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        Write-Host "npm is not installed. Opening the download page..."
        Start-Process "https://nodejs.org/en/download/prebuilt-installer/current"
        exit 1
    }
}

# Function to install npm packages
function Install-NpmPackages {
    Set-Location -Path $appPath
    Write-Host "Installing npm packages..."
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error installing npm packages."
        exit 1
    }
    Write-Host "Packages installed successfully."
}

# Function to run npm start
function Run-NpmStart {
    Write-Host "Starting the application..."
    npm run start
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error starting the application."
        exit 1
    }
}

# Main script
Check-NodeInstalled
Install-NpmPackages
Run-NpmStart
