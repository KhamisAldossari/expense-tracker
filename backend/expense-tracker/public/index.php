
<?php

require_once __DIR__ . '/../vendor/autoload.php';

header('Content-Type: application/json');

use App\Core\Request;
use App\Core\Router;

$request = new Request();
$router = new Router();

// Basic test route
$router->addRoute('GET', '/test', function() {
    return ['message' => 'API is working!'];
});

$response = $router->dispatch($request);
echo json_encode($response);