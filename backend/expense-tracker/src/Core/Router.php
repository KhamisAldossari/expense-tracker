<?php

namespace App\Core;

class Router {
    private array $routes = [];
    private array $middlewares = [];

    public function addRoute(string $method, string $path, callable|array $handler): void {
        $this->routes[] = [
            'method' => $method,
            'path' => $path,
            'handler' => $handler,
            'pattern' => $this->createPattern($path)
        ];
    }

    private function createPattern(string $path): string {
        return '#^' . preg_replace('#\{(\w+)\}#', '(?<$1>[^/]+)', $path) . '$#';
    }

    public function dispatch(Request $request): mixed {
        $method = $request->getMethod();
        $path = $request->getPath();

        foreach ($this->routes as $route) {
            if ($route['method'] !== $method) {
                continue;
            }

            if (preg_match($route['pattern'], $path, $matches)) {
                $params = array_filter(
                    $matches,
                    fn($key) => !is_numeric($key),
                    ARRAY_FILTER_USE_KEY
                );
                
                $request->setParams($params);
                
                if (is_array($route['handler'])) {
                    [$class, $method] = $route['handler'];
                    $controller = new $class();
                    return $controller->$method($request);
                }
                
                return $route['handler']($request);
            }
        }

        header("HTTP/1.0 404 Not Found");
        return ['error' => 'Route not found'];
    }
}
