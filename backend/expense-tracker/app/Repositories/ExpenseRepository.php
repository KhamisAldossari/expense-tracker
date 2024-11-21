<?php

namespace App\Repositories;

use App\Models\Expense;
use App\Repositories\Interfaces\ExpenseRepositoryInterface;

class ExpenseRepository implements ExpenseRepositoryInterface
{
    public function all(array $filters)
    {
        $query = Expense::with(['category', 'user']);
    
        if (!array_key_exists('user_id', $filters) || is_null($filters['user_id'])) {
            throw new \InvalidArgumentException('user_id filter is required');
        }
    
        $query->where('user_id', $filters['user_id']);
    
        return $query->get();
    }

    public function create(array $data)
    {
        return Expense::create($data);
    }

    public function find(int $id)
    {
        return Expense::findOrFail($id);
    }

    public function update(array $data, int $id)
    {
        $expense = $this->find($id);
        $expense->update($data);
        return $expense;
    }

    public function delete(int $id)
    {
        return $this->find($id)->delete();
    }
}