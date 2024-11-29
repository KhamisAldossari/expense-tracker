<?php

namespace App\Core;

use Firebase\JWT\JWT as FirebaseJWT;

class JWT 
{
    private static string $key = 'your-secret-key';  // Move to .env in production
    private static string $algorithm = 'HS256';
    
    public static function encode(array $payload): string 
    {
        return FirebaseJWT::encode($payload, self::$key, self::$algorithm);
    }
    
    public static function decode(string $token) 
    {
        try {
            return FirebaseJWT::decode($token, self::$key, [self::$algorithm]);
        } catch (\Exception $e) {
            return null;
        }
    }
}
