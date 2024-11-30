<?php

namespace App\Repositories\Interfaces;

interface ExpenseRepositoryInterface 
{
    public function all(array $filters): array;
    public function create(array $data): array;
    public function find(int $id): ?array;
    public function update(array $data, int $id): ?array;
    public function delete(int $id): bool;
}