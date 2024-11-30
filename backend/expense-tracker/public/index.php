<?php

require_once __DIR__ . '/../vendor/autoload.php';

// Load environment variables
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

header('Content-Type: application/json');

use App\Core\Request;
use App\Core\Router;
use App\Controllers\AuthController; 
use App\Controllers\CategoryController;
use App\Core\Middleware\AuthMiddleware;
use App\Controllers\ExpenseController;

$request = new Request();
$router = new Router();


$router->addMiddleware('/api/logout', AuthMiddleware::class);
$router->addMiddleware('/api/categories', AuthMiddleware::class);
$router->addMiddleware('/api/expenses', AuthMiddleware::class);


$router->addRoute('POST', '/api/register', [AuthController::class, 'register']);
$router->addRoute('POST', '/api/login', [AuthController::class, 'login']);
$router->addRoute('POST', '/api/logout', [AuthController::class, 'logout']);

$router->addRoute('GET', '/api/categories', [CategoryController::class, 'index']);
$router->addRoute('POST', '/api/categories', [CategoryController::class, 'store']);
$router->addRoute('DELETE', '/api/categories/{id}', [CategoryController::class, 'destroy']);


$router->addRoute('GET', '/api/expenses', [ExpenseController::class, 'index']);
$router->addRoute('POST', '/api/expenses', [ExpenseController::class, 'store']);
$router->addRoute('GET', '/api/expenses/{id}', [ExpenseController::class, 'show']);
$router->addRoute('PUT', '/api/expenses/{id}', [ExpenseController::class, 'update']);
$router->addRoute('DELETE', '/api/expenses/{id}', [ExpenseController::class, 'destroy']);

$response = $router->dispatch($request);
echo json_encode($response);