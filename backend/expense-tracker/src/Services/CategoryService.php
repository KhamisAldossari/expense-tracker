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

    public function getAllCategories(): array
    {
        return $this->categoryRepository->all();
    }

    public function createCategory(array $data): array
    {
        return $this->categoryRepository->create($data);
    }

    public function deleteCategory(int $id): bool
    {
        if (!$this->categoryRepository->find($id)) {
            throw new \Exception('Category not found');
        }
        return $this->categoryRepository->delete($id);
    }
}
