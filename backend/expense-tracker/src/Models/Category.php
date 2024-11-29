<?php

namespace App\Models;

use App\Core\Database;
use PDO;

class Category 
{
    private PDO $db;
    
    public function __construct() 
    {
        $this->db = Database::getInstance();
    }
    
    public function all(): array 
    {
        $stmt = $this->db->query("SELECT * FROM categories ORDER BY id");
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    public function create(array $data): array 
    {
        $stmt = $this->db->prepare("
            INSERT INTO categories (name) 
            VALUES (:name)
        ");
        
        $stmt->execute(['name' => $data['name']]);
        
        return $this->findById($this->db->lastInsertId());
    }
    
    public function findById(int $id): ?array 
    {
        $stmt = $this->db->prepare("SELECT * FROM categories WHERE id = :id");
        $stmt->execute(['id' => $id]);
        
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result ?: null;
    }
    
    public function delete(int $id): bool 
    {
        $stmt = $this->db->prepare("DELETE FROM categories WHERE id = :id");
        return $stmt->execute(['id' => $id]);
    }
}