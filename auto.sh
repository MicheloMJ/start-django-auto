#!/bin/bash

# Script to set up a new Django project with Django Jazzmin

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'  # No color

# Install necessary dependencies
sudo apt update
sudo apt install -y python3-venv python3-pip

cd "../"
echo -e "${GREEN}Enter the project name:${NC}"
read project_name
mkdir "$project_name"
cd "$project_name"

# Create and activate a virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Django and Django Jazzmin
pip install django
django-admin startproject "$project_name" .
pip install django-jazzmin

# Run initial migrations
python3 manage.py migrate

# Update the INSTALLED_APPS in settings.py
settings_file="$project_name/settings.py"
echo -e "\n${GREEN}Adding 'jazzmin' to INSTALLED_APPS in settings.py...${NC}"

# Insert 'jazzmin' at the beginning of INSTALLED_APPS
sed -i "/'django.contrib.staticfiles',/ s/'django.contrib.staticfiles',/ 'jazzmin', 'django.contrib.staticfiles',/" "$settings_file"

# Run initial migrations again after updating settings
python3 manage.py migrate

# Prompt for the development server port
echo -e "${GREEN}Press Enter to use the default port (8000) or enter a custom port:${NC}"
read -p "Port: " port
port=${port:-8000}

# Set the superuser username to the system name
username=$(whoami)

# Prompt for creating a superuser
echo -e "${GREEN}Do you want to create a superuser? (y/n):${NC}"
read -p "Choice: " create_superuser

if [ "$create_superuser" == "y" ]; then
    # Create a superuser interactively, entering the password when prompted
    python3 manage.py createsuperuser --username="$username"
    
    # Echo the password
    echo -e "\nSuperuser created with the following credentials:"
    echo -e "${GREEN}Username:${NC} $username"
    echo -e "${GREEN}Password:${NC} 12345678"  # Hardcoded password, change as needed
fi

cd ..

# Display the URL
echo -e "\n${BLUE}Django development server is running. Access the admin interface at:${NC}"
echo -e "${BLUE}http://127.0.0.1:$port/admin/${NC}"

# Run the development server
python3 "$project_name/manage.py" runserver "$port"
