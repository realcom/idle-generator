#!/bin/bash

# Set application path
app_path="./editor"

# Function to check if Node.js and npm are installed
check_node_installed() {
    if ! command -v node &> /dev/null; then
        echo "Node.js is not installed. Opening the download page..."
        xdg-open "https://nodejs.org/en/download/prebuilt-installer/current" 2> /dev/null || open "https://nodejs.org/en/download/prebuilt-installer/current"
        exit 1
    fi

    if ! command -v npm &> /dev/null; then
        echo "npm is not installed. Opening the download page..."
        xdg-open "https://nodejs.org/en/download/prebuilt-installer/current" 2> /dev/null || open "https://nodejs.org/en/download/prebuilt-installer/current"
        exit 1
    fi
}

# Function to install npm packages
install_npm_packages() {
    cd "$app_path"
    echo "Installing npm packages..."
    npm install
    if [[ $? -ne 0 ]]; then
        echo "Error installing npm packages."
        exit 1
    fi
    echo "Packages installed successfully."
}

# Function to run npm start
run_npm_start() {
    echo "Starting the application..."
    npm run start
    if [[ $? -ne 0 ]]; then
        echo "Error starting the application."
        exit 1
    fi
}

# Main script
check_node_installed
install_npm_packages
run_npm_start
