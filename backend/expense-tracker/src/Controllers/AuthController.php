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
        

        $validData = [
            'name' => $data['name'] ?? null,
            'email' => $data['email'] ?? null,
            'password' => $data['password'] ?? null
        ];
        
        if (empty($validData['name']) || empty($validData['email']) || empty($validData['password'])) {
            http_response_code(422);
            return ['error' => 'Name, email and password are required'];
        }
        
        if (!filter_var($validData['email'], FILTER_VALIDATE_EMAIL)) {
            http_response_code(422);
            return ['error' => 'Invalid email format'];
        }
        
        if (strlen($validData['password']) < 8) {
            http_response_code(422);
            return ['error' => 'Password must be at least 8 characters'];
        }
        
        try {
            $user = $this->authService->register($validData);
            $token = JWT::encode([
                'sub' => $user['id'],
                'email' => $user['email'],
                'iat' => time(),
                'exp' => time() + (60 * 60 * 24)
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
        
        $validData = [
            'email' => $data['email'] ?? null,
            'password' => $data['password'] ?? null
        ];
        
        if (empty($validData['email']) || empty($validData['password'])) {
            http_response_code(422);
            return ['error' => 'Email and password are required'];
        }
        
        try {
            $user = $this->authService->login($validData['email'], $validData['password']);
            $token = JWT::encode([
                'sub' => $user['id'],
                'email' => $user['email'],
                'iat' => time(),
                'exp' => time() + (60 * 60 * 24)
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
    
    // For consistency I have added this endpoint, however, no action is needed from the server side since we are using jwt
    public function logout(Request $request): array 
    {
        return ['message' => 'Successfully logged out'];
    }
}