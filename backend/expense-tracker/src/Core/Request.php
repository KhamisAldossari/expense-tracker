<?php

namespace App\Core;

class Request {
    private array $params;
    private array $query;
    private array $body;
    private array $headers;
    private string $method;
    private string $path;

    private ?array $user = null;

    public function __construct() {
        $this->params = [];
        $this->query = $_GET ?? [];
        $this->body = $this->getRequestBody();
        $this->headers = $this->parseHeaders();
        $this->method = $_SERVER['REQUEST_METHOD'];
        $this->path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    }

    private function getRequestBody(): array {
        $body = file_get_contents('php://input');
        return json_decode($body, true) ?? [];
    }

    private function parseHeaders(): array {
        $headers = [];
        foreach ($_SERVER as $key => $value) {
            if (strpos($key, 'HTTP_') === 0) {
                $headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($key, 5)))))] = $value;
            }
        }
        return $headers;
    }

    public function getMethod(): string {
        return $this->method;
    }

    public function getPath(): string {
        return $this->path;
    }

    public function getBody(): array {
        return $this->body;
    }

    public function getQuery(): array {
        return $this->query;
    }

    public function setParams(array $params): void {
        $this->params = $params;
    }

    public function getParams(): array {
        return $this->params;
    }
    // Add this public method to your Request class
    public function getHeaders(): array {
    return $this->headers;
    }

    public function setUser(array $user): void 
    {
        $this->user = $user;
    }

    public function user(): ?array 
    {
        return $this->user;
    }

    public function getClientIp(): string 
    {
        return $_SERVER['HTTP_CLIENT_IP'] 
            ?? $_SERVER['HTTP_X_FORWARDED_FOR'] 
            ?? $_SERVER['REMOTE_ADDR'] 
            ?? 'unknown';
    }
}
