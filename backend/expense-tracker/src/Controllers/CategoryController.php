<?php

namespace App\Controllers;

use App\Core\Request;
use App\Services\CategoryService;
use App\Repositories\CategoryRepository;

class CategoryController 
{
    private CategoryService $categoryService;
    
    public function __construct() 
    {
        $repository = new CategoryRepository();
        $this->categoryService = new CategoryService($repository);
    }
    
    public function index(Request $request): array 
    {
        return $this->categoryService->getAllCategories();
    }
    
    public function store(Request $request): array 
    {
        $data = $request->getBody();
        
        $validData = [
            'name' => $data['name'] ?? null
        ];
        
        if (empty($validData['name'])) {
            http_response_code(422);
            return ['error' => 'Name is required'];
        }
        
        try {
            http_response_code(201);
            return $this->categoryService->createCategory($validData);
        } catch (\Exception $e) {
            http_response_code(400);
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
            $this->categoryService->deleteCategory((int)$id);
            http_response_code(204);
            return [];
        } catch (\Exception $e) {
            http_response_code(404);
            return ['error' => $e->getMessage()];
        }
    }
}