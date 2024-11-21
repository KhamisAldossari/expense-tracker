<?php

namespace App\Repositories\Interfaces;

interface ExpenseRepositoryInterface
{
    public function all(array $filters);
    public function create(array $data);
    public function find(int $id);
    public function update(array $data, int $id);
    public function delete(int $id);
}