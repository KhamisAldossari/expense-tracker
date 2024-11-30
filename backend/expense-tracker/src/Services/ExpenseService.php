<?php

namespace App\Services;

use App\Repositories\Interfaces\ExpenseRepositoryInterface;

class ExpenseService 
{
    private ExpenseRepositoryInterface $expenseRepository;
    
    public function __construct(ExpenseRepositoryInterface $expenseRepository) 
    {
        $this->expenseRepository = $expenseRepository;
    }
    
    public function getAllExpenses(array $filters): array 
    {
        return $this->expenseRepository->all($filters);
    }
    
    public function createExpense(array $data, array $user): array 
    {
        $data['user_id'] = $user['id'];
        return $this->expenseRepository->create($data);
    }
    
    public function getExpense(int $id, array $user): array 
    {
        $expense = $this->expenseRepository->find($id);
        
        if (!$expense || !$this->expenseRepository->verifyOwnership($id, $user['id'])) {
            throw new \Exception('Expense not found');
        }
        
        return $expense;
    }
    
    public function updateExpense(array $data, int $id, array $user): array 
    {
        if (!$this->expenseRepository->verifyOwnership($id, $user['id'])) {
            throw new \Exception('Expense not found');
        }
        
        $expense = $this->expenseRepository->update($data, $id);
        if (!$expense) {
            throw new \Exception('Failed to update expense');
        }
        
        return $expense;
    }
    
    public function deleteExpense(int $id, array $user): void 
    {
        if (!$this->expenseRepository->verifyOwnership($id, $user['id'])) {
            throw new \Exception('Expense not found');
        }
        
        if (!$this->expenseRepository->delete($id)) {
            throw new \Exception('Failed to delete expense');
        }
    }
}
