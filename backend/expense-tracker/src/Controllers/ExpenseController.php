<?php

namespace App\Controllers;

use App\Core\Request;
use App\Services\ExpenseService;
use App\Repositories\ExpenseRepository;

class ExpenseController 
{
    private ExpenseService $expenseService;
    
    public function __construct() 
    {
        $repository = new ExpenseRepository();
        $this->expenseService = new ExpenseService($repository);
    }
    
    public function index(Request $request): array 
    {
        $user = $request->user();
        $expenses = $this->expenseService->getAllExpenses(['user_id' => $user['id']]);
        
        return ['data' => $expenses];
    }
    
    public function store(Request $request): array 
    {
        $data = $request->getBody();
        
        // Validation
        $required = ['category_id', 'amount', 'description', 'expense_date'];
        foreach ($required as $field) {
            if (empty($data[$field])) {
                http_response_code(422);
                return ['error' => ucfirst($field) . ' is required'];
            }
        }
        
        try {
            $expense = $this->expenseService->createExpense($data, $request->user());
            http_response_code(201);
            return ['data' => $expense];
        } catch (\Exception $e) {
            http_response_code(400);
            return ['error' => $e->getMessage()];
        }
    }
    
    public function show(Request $request): array 
    {
        $params = $request->getParams();
        $id = $params['id'] ?? null;
        
        if (!$id) {
            http_response_code(400);
            return ['error' => 'ID is required'];
        }
        
        try {
            $expense = $this->expenseService->getExpense((int)$id, $request->user());
            return ['data' => $expense];
        } catch (\Exception $e) {
            http_response_code(404);
            return ['error' => $e->getMessage()];
        }
    }
    
    public function update(Request $request): array 
    {
        $params = $request->getParams();
        $id = $params['id'] ?? null;
        $data = $request->getBody();
        
        if (!$id) {
            http_response_code(400);
            return ['error' => 'ID is required'];
        }
        
        if (empty($data)) {
            http_response_code(422);
            return ['error' => 'No data provided for update'];
        }
        
        try {
            $expense = $this->expenseService->updateExpense($data, (int)$id, $request->user());
            return ['data' => $expense];
        } catch (\Exception $e) {
            http_response_code(404);
            return ['error' => $e->getMessage()];
        }
    }
    
    public function destroy(Request $request): array 
    {
        $params = $request->getParams();
        $id = $params['id'] ?? null;
        
        if (!$id) {
            http_response_code(400);
            return ['error' => 'ID is required'];
        }
        
        try {
            $this->expenseService->deleteExpense((int)$id, $request->user());
            http_response_code(204);
            return [];
        } catch (\Exception $e) {
            http_response_code(404);
            return ['error' => $e->getMessage()];
        }
    }
}