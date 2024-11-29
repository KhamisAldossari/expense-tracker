<?php

namespace App\Repositories;

use App\Models\Category;
use App\Repositories\Interfaces\CategoryRepositoryInterface;

class CategoryRepository implements CategoryRepositoryInterface
{
    private Category $category;

    public function __construct()
    {
        $this->category = new Category();
    }

    public function all(): array
    {
        return $this->category->all();
    }

    public function create(array $data): array
    {
        return $this->category->create($data);
    }

    public function find(int $id): ?array
    {
        return $this->category->findById($id);
    }

    public function delete(int $id): bool
    {
        return $this->category->delete($id);
    }
}
