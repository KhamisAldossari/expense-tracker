<?php

namespace App\Http\Controllers;

use App\Http\Requests\ExpenseRequest;
use App\Http\Resources\ExpenseResource;
use App\Services\ExpenseService;
use Illuminate\Http\Request;

class ExpenseController extends Controller
{
    public function __construct(
        private ExpenseService $expenseService
    ) {}

    public function index(Request $request)
    {
        $filters = ['user_id' => $request->user()->id];
        $expenses = $this->expenseService->getAllExpenses($filters);
        return ExpenseResource::collection($expenses);
    }

    public function store(ExpenseRequest $request)
    {
        $expense = $this->expenseService->createExpense($request->validated());
        return new ExpenseResource($expense);
    }

    public function show(int $id)
    {
        $expense = $this->expenseService->getExpense($id);
        return new ExpenseResource($expense);
    }

    public function update(ExpenseRequest $request, int $id)
    {
        $expense = $this->expenseService->updateExpense($request->validated(), $id);
        return new ExpenseResource($expense);
    }

    public function destroy(int $id)
    {
        $this->expenseService->deleteExpense($id);
        return response()->noContent();
    }
}