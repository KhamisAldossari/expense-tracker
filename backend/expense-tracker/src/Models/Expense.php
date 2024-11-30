<?php

namespace App\Models;

use App\Core\Database;
use PDO;

class Expense 
{
    private PDO $db;
    
    public function __construct() 
    {
        $this->db = Database::getInstance();
    }
    
    public function create(array $data): array 
    {
        $stmt = $this->db->prepare("
            INSERT INTO expenses (user_id, category_id, amount, description, expense_date) 
            VALUES (:user_id, :category_id, :amount, :description, :expense_date)
        ");
        
        $stmt->execute($data);
        return $this->findById($this->db->lastInsertId());
    }
    
    public function findById(int $id): ?array 
    {
        $stmt = $this->db->prepare("
            SELECT e.*, c.name as category_name 
            FROM expenses e
            JOIN categories c ON e.category_id = c.id
            WHERE e.id = :id
        ");
        $stmt->execute(['id' => $id]);
        
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result ?: null;
    }
    
    public function findByUser(int $userId): array 
    {
        $stmt = $this->db->prepare("
            SELECT e.*, c.name as category_name 
            FROM expenses e
            JOIN categories c ON e.category_id = c.id
            WHERE e.user_id = :user_id
            ORDER BY e.expense_date DESC
        ");
        $stmt->execute(['user_id' => $userId]);
        
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    public function update(int $id, array $data): ?array 
    {
        $setClauses = [];
        $params = ['id' => $id];
        
        foreach ($data as $key => $value) {
            if (in_array($key, ['category_id', 'amount', 'description', 'expense_date'])) {
                $setClauses[] = "$key = :$key";
                $params[$key] = $value;
            }
        }
        
        if (empty($setClauses)) {
            return null;
        }
        
        $stmt = $this->db->prepare("
            UPDATE expenses 
            SET " . implode(', ', $setClauses) . "
            WHERE id = :id
        ");
        
        $stmt->execute($params);
        return $this->findById($id);
    }
    
    public function delete(int $id): bool 
    {
        $stmt = $this->db->prepare("DELETE FROM expenses WHERE id = :id");
        return $stmt->execute(['id' => $id]);
    }
    
    public function verifyOwnership(int $id, int $userId): bool 
    {
        $stmt = $this->db->prepare("
            SELECT id FROM expenses 
            WHERE id = :id AND user_id = :user_id
        ");
        $stmt->execute(['id' => $id, 'user_id' => $userId]);
        
        return (bool)$stmt->fetch();
    }
}
