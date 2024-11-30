<?php

namespace App\Repositories;

use App\Models\Expense;
use App\Repositories\Interfaces\ExpenseRepositoryInterface;

class ExpenseRepository implements ExpenseRepositoryInterface 
{
    private Expense $expense;
    
    public function __construct() 
    {
        $this->expense = new Expense();
    }
    
    public function all(array $filters): array 
    {
        return $this->expense->findByUser($filters['user_id']);
    }
    
    public function create(array $data): array 
    {
        return $this->expense->create($data);
    }
    
    public function find(int $id): ?array 
    {
        return $this->expense->findById($id);
    }
    
    public function update(array $data, int $id): ?array 
    {
        return $this->expense->update($id, $data);
    }
    
    public function delete(int $id): bool 
    {
        return $this->expense->delete($id);
    }
    
    public function verifyOwnership(int $id, int $userId): bool 
    {
        return $this->expense->verifyOwnership($id, $userId);
    }
}