#!/bin/bash

# Script to set up a new Django project with Django Jazzmin

echo "Enter the project name:"
read project_name
mkdir "$project_name"
cd "$project_name"
python3 -m venv venv
source venv/bin/activate
pip install django
django-admin startproject "$project_name" .
pip install django-jazzmin
echo -e "\nAdding 'jazzmin' to INSTALLED_APPS in settings.py..."
echo "INSTALLED_APPS += ['jazzmin']" >> "$project_name/settings.py"
python3 manage.py migrate
read -p "Enter the port for the development server (default is 8000): " port
port=${port:-8000}
read -p "Do you want to create a superuser? (y/n): " create_superuser

if [ "$create_superuser" == "y" ]; then
    # Set the superuser credentials
    username=$(whoami)
    password="admin"

    # Create a superuser
    python3 manage.py createsuperuser --noinput --username="$username" --email="$username@example.com"
    
    echo -e "\nSuperuser created with the following credentials:"
    echo "Username: $username"
    echo "Password: $password"
fi

# Display the URL
echo -e "\nDjango development server is running. Access the admin interface at:"
echo "http://127.0.0.1:$port/admin/"

# Run the development server
python3 manage.py runserver "$port"
