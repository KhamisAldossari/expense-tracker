import { useState, useMemo, useEffect, useCallback } from 'react'
import { useExpenseStore } from '@/stores/useExpenseStore'
import { Expense, ExpenseCreateUpdatePayload } from '@/types/expense'

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

interface ExpenseFormatters {
  date: (dateString: string) => string
  amount: (amount: number) => string
  percentage: (value: number) => string
}

interface FilterSetters {
  setSearchTerm: (searchTerm: string) => void
  setCategoryFilter: (categoryFilter: number | 'all') => void
  setSortBy: (sortBy: 'expense_date' | 'amount') => void
  setSortOrder: (sortOrder: 'asc' | 'desc') => void
}

export function useExpenses() {
  const {
    expenses,
    categories: categoriesResponse,
    addExpense: storeAddExpense,
    updateExpense: storeUpdateExpense,
    deleteExpense: storeDeleteExpense,
    fetchExpenses,
    fetchCategories,
    isLoading,
    error
  } = useExpenseStore()

  console.log('Raw expenses from store:', expenses)
  console.log('Categories from store:', categoriesResponse)

  const categories = useMemo(() => {
    return categoriesResponse || []
  }, [categoriesResponse])

  const [filters, setFilters] = useState<ExpenseFilters>({
    searchTerm: '',
    categoryFilter: 'all',
    sortBy: 'expense_date',
    sortOrder: 'desc'
  })

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

  const addExpense = useCallback(async (newExpense: Omit<Expense, "id"> & ExpenseCreateUpdatePayload) => {
    console.log('Adding new expense:', newExpense)
    
    if (!newExpense.category_id || !newExpense.description || !newExpense.amount) {
      throw new Error('Missing required expense fields')
    }

    try {
      await storeAddExpense({
        ...newExpense,
        amount: Number(newExpense.amount) // Ensure amount is a number
      })
    } catch (error) {
      console.error('[useExpenses] Failed to add expense:', error)
      throw error
    }
  }, [storeAddExpense])

  const updateExpense = useCallback(async (id: number, updatedExpense: ExpenseCreateUpdatePayload) => {
    console.log('Updating expense:', id, updatedExpense)
    
    if (!id || !updatedExpense.category_id) {
      throw new Error('Invalid expense update payload')
    }

    try {
      await storeUpdateExpense(id, {
        ...updatedExpense,
        amount: Number(updatedExpense.amount) // Ensure amount is a number
      })
    } catch (error) {
      console.error('[useExpenses] Failed to update expense:', error)
      throw error
    }
  }, [storeUpdateExpense])

  const deleteExpense = useCallback(async (id: number) => {
    console.log('Deleting expense:', id)
    
    if (!id) {
      throw new Error('Invalid expense ID')
    }

    try {
      await storeDeleteExpense(id)
    } catch (error) {
      console.error('[useExpenses] Failed to delete expense:', error)
      throw error
    }
  }, [storeDeleteExpense])

  const matchesSearch = useCallback((expense: Expense, term: string): boolean => {
    if (!term) return true
    if (!expense) return false

    const searchLower = term.toLowerCase().trim()
    
    const descriptionMatch = expense.description ? 
      expense.description.toLowerCase().includes(searchLower) : false
    
    const categoryMatch = expense.category?.name ? 
      expense.category.name.toLowerCase().includes(searchLower) : false
    
    return descriptionMatch || categoryMatch
  }, [])

  const matchesCategory = useCallback((expense: Expense, filter: number | 'all'): boolean => {
    if (!expense?.category) return false
    if (filter === 'all') return true
    return expense.category.id === filter
  }, [])

  const compareExpenses = useCallback((a: Expense, b: Expense, sortBy: 'expense_date' | 'amount', sortOrder: 'asc' | 'desc'): number => {
    const multiplier = sortOrder === 'asc' ? 1 : -1
    
    if (sortBy === 'expense_date') {
      const dateA = new Date(a.expense_date).getTime()
      const dateB = new Date(b.expense_date).getTime()
      return multiplier * (dateA - dateB)
    }
    
    const amountA = Number(a.amount)
    const amountB = Number(b.amount)
    return multiplier * (amountA - amountB)
  }, [])

  const filteredAndSortedExpenses = useMemo(() => {
    console.log('Filtering expenses:', expenses)
    
    if (!Array.isArray(expenses)) {
      console.log('Expenses is not an array')
      return []
    }

    const filtered = expenses.filter(expense => {
      if (!expense) {
        console.log('Invalid expense object:', expense)
        return false
      }

      const searchMatch = matchesSearch(expense, filters.searchTerm)
      const categoryMatch = matchesCategory(expense, filters.categoryFilter)
      
      console.log('Expense filtering:', {
        expense,
        searchMatch,
        categoryMatch
      })

      return searchMatch && categoryMatch
    })

    console.log('Filtered expenses:', filtered)

    const sorted = filtered.sort((a, b) => 
      compareExpenses(a, b, filters.sortBy, filters.sortOrder)
    )

    console.log('Sorted expenses:', sorted)
    return sorted
  }, [expenses, filters, matchesSearch, matchesCategory, compareExpenses])

  const totals = useMemo(() => {
    console.log('Calculating totals for expenses:', filteredAndSortedExpenses)

    if (!filteredAndSortedExpenses.length) {
      return {
        total: 0,
        byCategory: []
      }
    }

    const validExpenses = filteredAndSortedExpenses.filter(expense => {
      const amount = Number(expense.amount)
      const isValid = !isNaN(amount) && expense.category
      
      console.log('Validating expense:', {
        expense,
        amount,
        isValid
      })

      return isValid
    })

    console.log('Valid expenses for totals:', validExpenses)

    const total = validExpenses.reduce((sum, expense) => {
      const amount = Number(expense.amount)
      console.log('Adding to total:', { current: sum, adding: amount })
      return sum + amount
    }, 0)

    console.log('Calculated total:', total)

    const byCategory = validExpenses.reduce((acc, expense) => {
      const { id, name } = expense.category
      if (!acc[id]) {
        acc[id] = { 
          categoryId: id,
          categoryName: name,
          total: 0,
          percentage: 0
        }
      }
      
      const amount = Number(expense.amount)
      acc[id].total += amount
      
      console.log(`Category ${name} running total:`, acc[id].total)
      
      return acc
    }, {} as Record<number, CategoryTotal>)

    // Calculate percentages
    Object.values(byCategory).forEach(category => {
      category.percentage = total > 0 ? (category.total / total) * 100 : 0
    })

    const result = {
      total: Number(total.toFixed(2)),
      byCategory: Object.values(byCategory)
        .sort((a, b) => b.total - a.total)
    }

    console.log('Final totals:', result)
    return result
  }, [filteredAndSortedExpenses])

  const formatters: ExpenseFormatters = useMemo(() => ({
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

  const filterSetters: FilterSetters = useMemo(() => ({
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
    expenses: filteredAndSortedExpenses,
    categories,
    totals,
    addExpense,
    updateExpense,
    deleteExpense,
    filters,
    ...filterSetters,
    isLoading,
    error,
    formatters
  }
}