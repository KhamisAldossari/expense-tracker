<?php

namespace App\Controllers;

use App\Core\Request;
use App\Core\JWT;
use App\Services\AuthService;

class AuthController 
{
    private AuthService $authService;
    
    public function __construct() 
    {
        $this->authService = new AuthService();
    }
    
    public function register(Request $request): array 
    {
        $data = $request->getBody();
        

        if (empty($data['name']) || empty($data['email']) || empty($data['password'])) {
            http_response_code(422);
            return ['error' => 'Name, email and password are required'];
        }
        
        if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            http_response_code(422);
            return ['error' => 'Invalid email format'];
        }
        
        if (strlen($data['password']) < 8) {
            http_response_code(422);
            return ['error' => 'Password must be at least 8 characters'];
        }
        
        try {
            $user = $this->authService->register($data);
            $token = JWT::encode([
                'sub' => $user['id'],
                'email' => $user['email'],
                'iat' => time(),
                'exp' => time() + (60 * 60 * 24) // 24 hours
            ]);
            
            http_response_code(201);
            return [
                'user' => $user,
                'token' => $token
            ];
        } catch (\Exception $e) {
            http_response_code(400);
            return ['error' => $e->getMessage()];
        }
    }
    
    public function login(Request $request): array 
    {
        $data = $request->getBody();
        
        if (empty($data['email']) || empty($data['password'])) {
            http_response_code(422);
            return ['error' => 'Email and password are required'];
        }
        
        try {
            $user = $this->authService->login($data['email'], $data['password']);
            $token = JWT::encode([
                'sub' => $user['id'],
                'email' => $user['email'],
                'iat' => time(),
                'exp' => time() + (60 * 60 * 24) // 24 hours
            ]);
            
            return [
                'user' => $user,
                'token' => $token
            ];
        } catch (\Exception $e) {
            http_response_code(401);
            return ['error' => $e->getMessage()];
        }
    }
}