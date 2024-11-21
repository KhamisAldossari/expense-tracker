<?php

namespace App\Services;

use App\Repositories\Interfaces\ExpenseRepositoryInterface;

class ExpenseService
{

    private LoggingService $loggingService;

    public function __construct(
        private ExpenseRepositoryInterface $expenseRepository,
        LoggingService $loggingService
    ) {
        $this->loggingService = $loggingService;
    }

    public function getAllExpenses(array $filters)
    {
        return $this->expenseRepository->all($filters);
    }

    public function createExpense(array $data)
    {
        $userId = auth()->id();

        $data['user_id'] = $userId;
        $expense = $this->expenseRepository->create($data);
        $this->loggingService->logExpenseActivity('created', $expense->toArray());
        return $expense;
    }

    public function getExpense(int $id)
    {
        return $this->expenseRepository->find($id);
    }

    public function updateExpense(array $data, int $id)
    {
        $oldExpense = $this->expenseRepository->find($id);
        $expense = $this->expenseRepository->update($data, $id);
        $this->loggingService->logExpenseActivity(
            'updated', 
            $expense->toArray(),
            $oldExpense->toArray()
        );
        return $expense;
    }

    public function deleteExpense(int $id)
    {
        $expense = $this->expenseRepository->find($id);
        $this->loggingService->logExpenseActivity('deleted', $expense->toArray());
        $this->expenseRepository->delete($id);
        return $expense;
    }
}