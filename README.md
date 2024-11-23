# Expense Tracker Application

A full-stack expense tracking application built with Laravel (Backend) and React (Frontend). The application allows users to manage their expenses with features like authentication, CRUD operations for expenses, and category management.

## Technologies Used

- **Backend:**
  - PHP Laravel
  - MySQL 8.0 (Docker)
  - Laravel Sanctum for authentication
  - RESTful APIs

- **Frontend:**
  - React + Vite
  - TypeScript
  - Tailwind CSS
  - Shadcn/ui components
  - Zustand for state management

## Prerequisites

Before you begin, ensure you have installed:
- PHP >= 8.1
- Composer
- Node.js >= 16
- Docker
- Git

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/KhamisAldossari/expense-tracker
cd expense-tracker
```

### 2. Backend Setup (Laravel)

```bash
# Navigate to backend directory
cd backend/expense-tracker

# Install PHP dependencies
composer install

# Copy environment file
cp .env.example .env

# Configure your .env file with your MySQL credentials:
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=expense_tracker
DB_USERNAME=your_username
DB_PASSWORD=your_password


# Pull and run MySQL container and configure the database using the credintials used previously
docker pull mysql:8.0
docker run --name mysql_expense_tracker -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=expense_tracker -e MYSQL_USER=<your_username> -e MYSQL_PASSWORD=<your_password> -p 3306:3306 -d mysql:8.0

# Generate application key
php artisan key:generate

# Run database migrations
php artisan migrate

# Start the Laravel development server
php artisan serve
```

### 3. Frontend Setup (React + Vite)

```bash
# Navigate to frontend directory
cd frontend/expense-tracker

# Install dependencies
npm install

# Start the development server
npm run dev
```

## Available API Endpoints

The following API endpoints are available:

### Authentication
- `POST /api/register` - User registration
- `POST /api/login` - User login
- `POST /api/logout` - User logout

### Expenses
- `GET /api/expenses` - Fetch all expenses
- `POST /api/expenses` - Add new expense
- `PUT /api/expenses/{id}` - Update expense
- `DELETE /api/expenses/{id}` - Delete expense

### Categories
- `GET /api/categories` - Fetch all categories

## Starting the Application

1. Start the MySQL container
2. Start the Laravel backend server:
```bash
cd backend/expense-tracker
php artisan serve
```
The backend will be available at `http://localhost:8000`

3. Start the React frontend development server:
```bash
cd frontend/expense-tracker
npm run dev
```
The frontend will be available at `http://localhost:3000`

## Application Features

- User Authentication (Sign Up/Sign In)
- Expense Management (CRUD operations)
- Category Management
- Expense Filtering and Sorting
- Responsive Design
- Real-time Updates


## Demo

Watch the demo video of the Expense Tracker Application:

[![Expense Tracker Demo](https://img.youtube.com/vi/B28yi8MiVh8/0.jpg)](https://youtu.be/B28yi8MiVh8)

