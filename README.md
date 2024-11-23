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
- Docker and Docker Compose
- Git

## Installation

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd expense-tracker
```

### 2. Backend Setup (Laravel)

```bash
# Navigate to backend directory
cd backend

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

# Generate application key
php artisan key:generate

# Run database migrations and seeders
php artisan migrate --seed

# Start the Laravel development server
php artisan serve
```

### 3. Database Setup (MySQL with Docker)

```bash
# Start MySQL container
docker-compose up -d

# The MySQL service will be available at:
# Host: localhost
# Port: 3306
# Database: expense_tracker
```

### 4. Frontend Setup (React + Vite)

```bash
# Navigate to frontend directory
cd frontend

# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Configure your .env file:
VITE_API_URL=http://localhost:8000/api

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

1. Start the MySQL container:
```bash
docker-compose up -d
```

2. Start the Laravel backend server:
```bash
cd backend
php artisan serve
```
The backend will be available at `http://localhost:8000`

3. Start the React frontend development server:
```bash
cd frontend
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

## Development Scripts

### Frontend
```bash
# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run TypeScript type checking
npm run type-check
```

### Backend
```bash
# Run migrations
php artisan migrate

# Seed the database
php artisan db:seed

# Clear cache
php artisan cache:clear

# Generate API documentation
php artisan l5-swagger:generate
```


## Demo

Watch the demo video of the Expense Tracker Application:

[![Expense Tracker Demo](https://img.youtube.com/vi/B28yi8MiVh8/0.jpg)](https://youtu.be/B28yi8MiVh8)


## Project Structure

```
expense-tracker/
├── backend/                # Laravel backend
│   ├── app/
│   ├── database/
│   ├── routes/
│   └── ...
├── frontend/              # React frontend
│   ├── src/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── pages/
│   │   ├── services/
│   │   ├── stores/
│   │   └── types/
│   └── ...
└── README.md
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE.md file for details

## Acknowledgments

- [Laravel](https://laravel.com/)
- [React](https://reactjs.org/)
- [Vite](https://vitejs.dev/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Shadcn/ui](https://ui.shadcn.com/)