<?php

namespace App\Services;

use App\Repositories\Interfaces\ExpenseRepositoryInterface;

class ExpenseService 
{
    private ExpenseRepositoryInterface $expenseRepository;
    private LoggingService $loggingService;
    
    public function __construct(ExpenseRepositoryInterface $expenseRepository) 
    {
        $this->expenseRepository = $expenseRepository;
        $this->loggingService = new LoggingService();
    }
    
    public function getAllExpenses(array $filters): array 
    {
        $expenses = $this->expenseRepository->all($filters);
        $this->loggingService->logExpenseActivity('list', ['filters' => $filters]);
        return $expenses;
    }
    
    public function createExpense(array $data, array $user): array 
    {
        $data['user_id'] = $user['id'];
        $expense = $this->expenseRepository->create($data);
        $this->loggingService->logExpenseActivity('create', $expense);
        return $expense;
    }
    
    public function getExpense(int $id, array $user): array 
    {
        $expense = $this->expenseRepository->find($id);
        
        if (!$expense || !$this->expenseRepository->verifyOwnership($id, $user['id'])) {
            throw new \Exception('Expense not found');
        }
        
        $this->loggingService->logExpenseActivity('view', $expense);
        return $expense;
    }
    
    public function updateExpense(array $data, int $id, array $user): array 
    {
        if (!$this->expenseRepository->verifyOwnership($id, $user['id'])) {
            throw new \Exception('Expense not found');
        }
        
        $oldData = $this->expenseRepository->find($id);
        $expense = $this->expenseRepository->update($data, $id);
        
        if (!$expense) {
            throw new \Exception('Failed to update expense');
        }
        
        $this->loggingService->logExpenseActivity('update', $expense, $oldData);
        return $expense;
    }
    
    public function deleteExpense(int $id, array $user): void 
    {
        if (!$this->expenseRepository->verifyOwnership($id, $user['id'])) {
            throw new \Exception('Expense not found');
        }
        
        $expense = $this->expenseRepository->find($id);
        
        if (!$this->expenseRepository->delete($id)) {
            throw new \Exception('Failed to delete expense');
        }
        
        $this->loggingService->logExpenseActivity('delete', $expense);
    }
}