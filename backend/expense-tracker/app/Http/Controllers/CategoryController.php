<?php

namespace App\Http\Controllers;

use App\Http\Requests\CategoryRequest;
use App\Http\Resources\CategoryResource;
use App\Services\CategoryService;

class CategoryController extends Controller
{
    public function __construct(
        private CategoryService $categoryService
    ) {}

    public function index()
    {
        $categories = $this->categoryService->getAllCategories();
        return CategoryResource::collection($categories);
    }

    public function store(CategoryRequest $request)
    {
        $category = $this->categoryService->createCategory($request->validated());
        return new CategoryResource($category);
    }

    public function destroy(int $id)
    {
        $this->categoryService->deleteCategory($id);
        return response()->noContent();
    }
}