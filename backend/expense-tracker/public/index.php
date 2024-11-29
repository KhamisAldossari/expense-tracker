<?php

require_once __DIR__ . '/../vendor/autoload.php';

// For loading .env
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

header('Content-Type: application/json');

use App\Core\Request;
use App\Core\Router;
use App\Controllers\CategoryController;

$request = new Request();
$router = new Router();

// Test route
$router->addRoute('GET', '/api/test', function() {
    return ['message' => 'API is working!'];
});

// Category routes
$router->addRoute('GET', '/api/categories', [CategoryController::class, 'index']);
$router->addRoute('POST', '/api/categories', [CategoryController::class, 'store']);
$router->addRoute('DELETE', '/api/categories/{id}', [CategoryController::class, 'destroy']);

$response = $router->dispatch($request);
echo json_encode($response);