#!/bin/bash

# Script to set up a new Django project with Django Jazzmin

# ANSI color codes
GREEN='\033[0;32m'
NC='\033[0m'  # No color

# Install necessary dependencies
sudo apt update
sudo apt install -y python3-venv python3-pip

echo -e "${GREEN}Enter the project name:${NC}"
read project_name
cd "../"
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
sed -i "/'django.contrib.staticfiles',/ a \ \ \ \ 'jazzmin'," "$settings_file"

# Run initial migrations again after updating settings
python3 manage.py migrate

# Prompt for the development server port
echo -e "${GREEN}Press Enter to use the default port (8000) or enter a custom port:${NC}"
read -p "Port: " port
port=${port:-8000}

# Prompt for creating a superuser
echo -e "${GREEN}Do you want to create a superuser? (y/n):${NC}"
read -p "Choice: " create_superuser

if [ "$create_superuser" == "y" ]; then
    # Set the superuser credentials
    echo -e "${GREEN}Enter the superuser's username:${NC}"
    read -p "Username: " username
    echo -e "${GREEN}Enter the superuser's email address:${NC}"
    read -p "Email: " email
    read -s -p "${GREEN}Enter the superuser's password:${NC}" password
    echo  # Move to a new line after reading the password
    
    # Create a superuser
    python3 manage.py createsuperuser --noinput --username="$username" --email="$email" --password="$password"
    
    echo -e "\nSuperuser created with the following credentials:"
    echo -e "${GREEN}Username:${NC} $username"
    echo -e "${GREEN}Email:${NC} $email"
fi

# Move back one step out of the current folder
cd ..

# Display the URL
echo -e "\n${GREEN}Django development server is running. Access the admin interface at:${NC}"
echo -e "${GREEN}http://127.0.0.1:$port/admin/${NC}"

# Run the development server
python3 "$project_name/manage.py" runserver "$port"
