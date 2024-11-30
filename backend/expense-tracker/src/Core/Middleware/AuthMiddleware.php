<?php

namespace App\Core\Middleware;

use App\Core\Request;
use App\Core\JWT;

class AuthMiddleware 
{
    public function handle(Request $request): ?array 
    {
        $authorization = $request->getHeaders()['Authorization'] ?? null;
        
        if (!$authorization || !str_starts_with($authorization, 'Bearer ')) {
            http_response_code(401);
            return ['error' => 'Unauthorized'];
        }
        
        $token = substr($authorization, 7);
        $payload = JWT::decode($token);
        
        if (!$payload) {
            http_response_code(401);
            return ['error' => 'Invalid token'];
        }
        

        $request->setUser([
            'id' => $payload->sub,
            'email' => $payload->email
        ]);
        
        return null;
    }
}
