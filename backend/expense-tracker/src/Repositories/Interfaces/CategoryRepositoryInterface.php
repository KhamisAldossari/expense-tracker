<?php

namespace App\Repositories\Interfaces;

interface CategoryRepositoryInterface
{
    public function all(): array;
    public function create(array $data): array;
    public function find(int $id): ?array;
    public function delete(int $id): bool;
}