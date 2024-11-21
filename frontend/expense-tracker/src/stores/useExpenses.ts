import { useState, useMemo, useEffect } from 'react'
import { useExpenseStore } from '@/stores/useExpenseStore'
import { Expense } from '@/types/expense'

export function useExpenses() {
  const {
    expenses,
    categories,
    addExpense: storeAddExpense,
    updateExpense: storeUpdateExpense,
    deleteExpense: storeDeleteExpense,
    fetchExpenses,
    fetchCategories,
    token,
    isLoading,
    error
  } = useExpenseStore()

  const [searchTerm, setSearchTerm] = useState('')
  const [categoryFilter, setCategoryFilter] = useState('all')
  const [sortBy, setSortBy] = useState<'date' | 'amount'>('date')
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('desc')

  useEffect(() => {
    fetchExpenses()
    fetchCategories()
    
  }, [fetchExpenses, fetchCategories])

  const addExpense = async (newExpense: Omit<Expense, 'id'>) => {
    await storeAddExpense(newExpense)
  }

  const updateExpense = async (updatedExpense: Expense) => {
    await storeUpdateExpense(updatedExpense.id, updatedExpense)
  }

  const deleteExpense = async (id: number) => {
    await storeDeleteExpense(id)
  }

  const filteredAndSortedExpenses = useMemo(() => {
    return [...expenses]
      .filter(expense =>
        (expense.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
         expense.category.toLowerCase().includes(searchTerm.toLowerCase())) &&
        (categoryFilter === 'all' || expense.category === categoryFilter)
      )
      .sort((a, b) => {
        if (sortBy === 'date') {
          return sortOrder === 'asc' 
            ? new Date(a.date).getTime() - new Date(b.date).getTime()
            : new Date(b.date).getTime() - new Date(a.date).getTime()
        } else {
          return sortOrder === 'asc' ? a.amount - b.amount : b.amount - a.amount
        }
      })
  }, [expenses, searchTerm, categoryFilter, sortBy, sortOrder])

  const totalSpend = useMemo(() => {
    return filteredAndSortedExpenses.reduce((sum, expense) => sum + expense.amount, 0)
  }, [filteredAndSortedExpenses])

  return {
    expenses: filteredAndSortedExpenses,
    categories,
    addExpense,
    updateExpense,
    deleteExpense,
    totalSpend,
    searchTerm,
    setSearchTerm,
    categoryFilter,
    setCategoryFilter,
    sortBy,
    setSortBy,
    sortOrder,
    setSortOrder,
    isLoading,
    error
  }
}