<?php

namespace App\Core;

use Firebase\JWT\JWT as FirebaseJWT;
use Firebase\JWT\Key;

class JWT 
{
    private static function getKey(): string
    {
        $key = $_ENV['JWT_SECRET'] ?? null;
        if (!$key) {
            throw new \RuntimeException('JWT_SECRET from .env is not set');
        }
        return $key;
    }
    
    private static string $algorithm = 'HS256';
    
    public static function encode(array $payload): string 
    {
        return FirebaseJWT::encode($payload, self::getKey(), self::$algorithm);
    }
    
    public static function decode(string $token) 
    {
        try {
            return FirebaseJWT::decode($token, new Key(self::getKey(), self::$algorithm));
        } catch (\Exception $e) {
            return null;
        }
    }
}