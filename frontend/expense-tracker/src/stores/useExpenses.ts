import { useState, useMemo, useEffect, useCallback } from 'react'
import { useExpenseStore } from '@/stores/useExpenseStore'
import { Expense, ExpenseCreateUpdatePayload, Category } from '@/types/expense'

interface ExpenseFilters {
  searchTerm: string
  categoryFilter: number | 'all'
  sortBy: 'expense_date' | 'amount'
  sortOrder: 'asc' | 'desc'
}

interface CategoryTotal {
  categoryId: number
  categoryName: string
  total: number
  percentage: number
}

export function useExpenses() {
  // State from store
  const {
    expenses,
    categories,
    addExpense: storeAddExpense,
    updateExpense: storeUpdateExpense,
    deleteExpense: storeDeleteExpense,
    fetchExpenses,
    fetchCategories,
    isLoading,
    error
  } = useExpenseStore()

  // Local state for filters
  const [filters, setFilters] = useState<ExpenseFilters>({
    searchTerm: '',
    categoryFilter: 'all',
    sortBy: 'expense_date',
    sortOrder: 'desc'
  })

  // Data fetching
  useEffect(() => {
    const fetchData = async () => {
      try {
        await Promise.all([fetchExpenses(), fetchCategories()])
      } catch (error) {
        console.error('[useExpenses] Failed to fetch initial data:', error)
      }
    }
    fetchData()
  }, [fetchExpenses, fetchCategories])

  // CRUD operations with proper error handling
  const addExpense = useCallback(async (newExpense: Omit<Expense ,"id">&ExpenseCreateUpdatePayload) => {
    try {
      await storeAddExpense(newExpense)
    } catch (error) {
      console.error('[useExpenses] Failed to add expense:', error)
      throw error
    }
  }, [storeAddExpense])

  const updateExpense = useCallback(async (id: number, updatedExpense: ExpenseCreateUpdatePayload) => {
    try {
      await storeUpdateExpense(id, updatedExpense)
    } catch (error) {
      console.error('[useExpenses] Failed to update expense:', error)
      throw error
    }
  }, [storeUpdateExpense])

  const deleteExpense = useCallback(async (id: number) => {
    try {
      await storeDeleteExpense(id)
    } catch (error) {
      console.error('[useExpenses] Failed to delete expense:', error)
      throw error
    }
  }, [storeDeleteExpense])

  // Filter helpers
  const matchesSearch = useCallback((expense: Expense, term: string): boolean => {
    const searchLower = term.toLowerCase()
    return expense.description.toLowerCase().includes(searchLower) ||
           expense.category.name.toLowerCase().includes(searchLower)
  }, [])

  const matchesCategory = useCallback((expense: Expense, filter: number | 'all'): boolean => {
    return filter === 'all' || expense.category.id === filter
  }, [])

  // Sorting helper
  const compareExpenses = useCallback((a: Expense, b: Expense, sortBy: 'expense_date' | 'amount', sortOrder: 'asc' | 'desc'): number => {
    const multiplier = sortOrder === 'asc' ? 1 : -1
    
    if (sortBy === 'expense_date') {
      return multiplier * (new Date(a.expense_date).getTime() - new Date(b.expense_date).getTime())
    }
    
    const amountA = a.amount
    const amountB = b.amount
    return multiplier * (amountA - amountB)
  }, [])

  // Memoized filtered and sorted expenses
  const filteredAndSortedExpenses = useMemo(() => {
    return [...expenses]
      .filter(expense => 
        matchesSearch(expense, filters.searchTerm) && 
        matchesCategory(expense, filters.categoryFilter)
      )
      .sort((a, b) => compareExpenses(a, b, filters.sortBy, filters.sortOrder))
  }, [expenses, filters, matchesSearch, matchesCategory, compareExpenses])

  // Memoized calculations
  const totals = useMemo(() => {
    const total = filteredAndSortedExpenses.reduce((sum, expense) => 
      sum + expense.amount, 0
    )

    const byCategory = filteredAndSortedExpenses.reduce((acc, expense) => {
      const { id, name } = expense.category
      if (!acc[id]) {
        acc[id] = { 
          categoryId: id,
          categoryName: name,
          total: 0,
          percentage: 0
        }
      }
      acc[id].total += expense.amount
      return acc
    }, {} as Record<number, CategoryTotal>)

    // Calculate percentages
    Object.values(byCategory).forEach(category => {
      category.percentage = (category.total / total) * 100
    })

    return {
      total: total.toFixed(2),
      byCategory: Object.values(byCategory)
        .sort((a, b) => b.total - a.total) // Sort by total descending
    }
  }, [filteredAndSortedExpenses])

  // Utility functions
  const formatters = useMemo(() => ({
    date: (dateString: string) => new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    }),
    
    amount: (amount: number) => new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount),
    
    percentage: (value: number) => `${value.toFixed(1)}%`
  }), [])

  // Filter setters
  const filterSetters = useMemo(() => ({
    setSearchTerm: (searchTerm: string) => 
      setFilters(prev => ({ ...prev, searchTerm })),
    
    setCategoryFilter: (categoryFilter: number | 'all') => 
      setFilters(prev => ({ ...prev, categoryFilter })),
    
    setSortBy: (sortBy: 'expense_date' | 'amount') => 
      setFilters(prev => ({ ...prev, sortBy })),
    
    setSortOrder: (sortOrder: 'asc' | 'desc') => 
      setFilters(prev => ({ ...prev, sortOrder }))
  }), [])

  return {
    // Data
    expenses: filteredAndSortedExpenses,
    categories,
    totals,
    
    // Actions
    addExpense,
    updateExpense,
    deleteExpense,
    
    // Filters
    filters,
    ...filterSetters,
    
    // Status
    isLoading,
    error,
    
    // Utilities
    formatters
  }
}