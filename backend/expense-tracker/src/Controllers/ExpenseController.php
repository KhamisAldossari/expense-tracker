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
        $filters = ['user_id' => $user['id']];
        return $this->expenseService->getAllExpenses($filters);
    }
    
    public function store(Request $request): array 
    {
        $data = $request->getBody();
        
        $validData = [
            'category_id' => $data['category_id'] ?? null,
            'amount' => $data['amount'] ?? null,
            'description' => $data['description'] ?? null,
            'expense_date' => $data['expense_date'] ?? null
        ];
        
        $required = ['category_id', 'amount', 'description', 'expense_date'];
        foreach ($required as $field) {
            if (empty($validData[$field])) {
                http_response_code(422);
                return ['error' => ucfirst(str_replace('_', ' ', $field)) . ' is required'];
            }
        }
        
        try {
            $expense = $this->expenseService->createExpense($validData, $request->user());
            http_response_code(201);
            return $expense;
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
            return $this->expenseService->getExpense((int)$id, $request->user());
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
        
        $validData = array_intersect_key($data, array_flip([
            'category_id',
            'amount',
            'description',
            'expense_date'
        ]));
        
        if (empty($validData)) {
            http_response_code(422);
            return ['error' => 'No valid fields provided for update'];
        }
        
        try {
            return $this->expenseService->updateExpense($validData, (int)$id, $request->user());
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