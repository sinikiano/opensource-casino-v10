#!/bin/bash

echo "🚀 Setting up Casino Platform..."

# Start MySQL/MariaDB
sudo service mariadb start

# Wait for MySQL to be ready
sleep 3

# Create database and user
sudo mysql -e "CREATE DATABASE IF NOT EXISTS casino;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'casino'@'localhost' IDENTIFIED BY 'casino123';"
sudo mysql -e "GRANT ALL PRIVILEGES ON casino.* TO 'casino'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "📦 Importing database..."
sudo mysql casino < v105.sql

echo "📦 Installing Composer dependencies..."
cd casino
composer install --ignore-platform-req=ext-sodium

# Copy environment file and configure
cp .env.example .env

# Update .env with database credentials
sed -i 's/DB_DATABASE=laravel/DB_DATABASE=casino/' .env
sed -i 's/DB_USERNAME=root/DB_USERNAME=casino/' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=casino123/' .env

# Generate application key
php artisan key:generate

echo "✅ Setup complete!"
echo ""
echo "To start the server, run:"
echo "  cd casino && php artisan serve --host=0.0.0.0 --port=8000"
echo ""
echo "Or from the root directory:"
echo "  php -S 0.0.0.0:8000"
