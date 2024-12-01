<?php

namespace App\Services;

use App\Repositories\Interfaces\CategoryRepositoryInterface;

class CategoryService 
{
    private CategoryRepositoryInterface $categoryRepository;
    
    public function __construct(CategoryRepositoryInterface $categoryRepository) 
    {
        $this->categoryRepository = $categoryRepository;
    }
    
    private function formatCategory(array $category): array 
    {
        return [
            'id' => $category['id'],
            'name' => $category['name']
        ];
    }
    
    public function getAllCategories(): array 
    {
        $categories = $this->categoryRepository->all();
        return array_map([$this, 'formatCategory'], $categories);
    }
    
    public function createCategory(array $data): array 
    {
        $category = $this->categoryRepository->create($data);
        return $this->formatCategory($category);
    }
    
    public function deleteCategory(int $id): void 
    {
        $this->categoryRepository->delete($id);
    }
}
