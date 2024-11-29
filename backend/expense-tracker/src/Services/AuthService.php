<?php

namespace App\Services;

use App\Models\User;

class AuthService 
{
    private User $user;
    
    public function __construct() 
    {
        $this->user = new User();
    }
    
    public function register(array $data): array 
    {

        if ($this->user->findByEmail($data['email'])) {
            throw new \Exception('Email already exists');
        }
        

        $data['password'] = password_hash($data['password'], PASSWORD_DEFAULT);
        

        $user = $this->user->create($data);
        

        unset($user['password']);
        
        return $user;
    }
    
    public function login(string $email, string $password): array 
    {
        $user = $this->user->findByEmail($email);
        
        if (!$user || !password_verify($password, $user['password'])) {
            throw new \Exception('Invalid credentials');
        }
        

        unset($user['password']);
        
        return $user;
    }
}