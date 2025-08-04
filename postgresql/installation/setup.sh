#!/bin/bash

echo "========================================="
echo "     Postgresql setup by imadzajli"
echo "========================================="

echo "Note : This should work fine for debian based systems !!!!!"

print_decorated() {
    echo
    echo "--- $1 ---"
}

printx() {
    echo
    echo "**********************************"
    echo "      $1      "
    echo "**********************************"
    echo 
}

print_decorated "Operating System"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then

echo "OS type : Linux"

elif [[ "$OSTYPE" == "darwin"* ]]; then

echo "OS type : Mac"

elif [[ "$OSTYPE" == "cygwin" ]]; then
    echo "OS type: Cygwin (Windows)"
    
elif [[ "$OSTYPE" == "msys" ]]; then
    echo "OS type: MSYS (Windows)"

else 
    echo "OS Type: Unknown ($OSTYPE)"

fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then

printx "update and upgrade sys"

sudo apt update && sudo apt upgrade -y

printx "Install prerequisites"

sudo apt install -y curl gnupg2 lsb-release ca-certificates

printx "Import Postgresql GPG key"

curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /usr/share/keyrings/postgresql.gpg

printx "Add the official repository"

echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list > /dev/null

printx "update package list"

sudo apt update

printx "install the latest stable version"

sudo apt install -y postgresql postgresql-contrib


printx "Checking postgres installation"


if psql --version >/dev/null 2>&1; then
    echo "✓ psql installed successfully"
    echo "Version: $(psql --version)"
else
    echo "✗ psql installation failed"
fi
fi