<?php

namespace App\Models;

use App\Core\Database;
use PDO;

class User 
{
    private PDO $db;
    
    public function __construct() 
    {
        $this->db = Database::getInstance();
    }
    
    public function create(array $data): array 
    {
        $stmt = $this->db->prepare("
            INSERT INTO users (name, email, password) 
            VALUES (:name, :email, :password)
        ");
        
        $stmt->execute([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => $data['password']
        ]);
        
        return $this->findById($this->db->lastInsertId());
    }
    
    public function findById(int $id): ?array 
    {
        $stmt = $this->db->prepare("SELECT id, name, email, created_at FROM users WHERE id = :id");
        $stmt->execute(['id' => $id]);
        
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result ?: null;
    }
    
    public function findByEmail(string $email): ?array 
    {
        $stmt = $this->db->prepare("SELECT * FROM users WHERE email = :email");
        $stmt->execute(['email' => $email]);
        
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result ?: null;
    }
}
