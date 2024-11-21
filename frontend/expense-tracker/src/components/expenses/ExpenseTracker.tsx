"use client"

import { useState } from 'react'
import { ExpenseDashboard } from './ExpenseDashboard'
import { ExpenseFilters } from './ExpenseFilters'
import { ExpenseList } from './ExpenseList'
import { AddExpenseDialog } from './AddExpenseDialog'
import { UpdateExpenseDialog } from './UpdateExpenseDialog'
import { useExpenses } from '@/stores/useExpenses'
import { Expense } from '@/types/expense'

export default function ExpenseTracker() {
  const {
    expenses,
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
    
  } = useExpenses()

  const [isAddExpenseOpen, setIsAddExpenseOpen] = useState(false)
  const [isUpdateExpenseOpen, setIsUpdateExpenseOpen] = useState(false)
  const [currentExpense, setCurrentExpense] = useState<Expense | null>(null)

  const handleUpdate = (expense: Expense) => {
    setCurrentExpense(expense)
    setIsUpdateExpenseOpen(true)
  }

  if (isLoading) {
    return <div className="container mx-auto p-4">Loading expenses...</div>
  }

  if (error) {
    return <div className="container mx-auto p-4 text-red-500">Error: {error}</div>
  }

  return (
    <div className="container mx-auto p-4">
      <ExpenseDashboard totalSpend={totalSpend} />

      <ExpenseFilters
        searchTerm={searchTerm}
        setSearchTerm={setSearchTerm}
        categoryFilter={categoryFilter}
        setCategoryFilter={setCategoryFilter}
        sortBy={sortBy}
        setSortBy={setSortBy}
        sortOrder={sortOrder}
        setSortOrder={setSortOrder}
        setIsAddExpenseOpen={setIsAddExpenseOpen}
        categories={categories}
      />

      <ExpenseList
        expenses={expenses}
        onUpdate={handleUpdate}
        onDelete={deleteExpense}
      />

      <AddExpenseDialog
        isOpen={isAddExpenseOpen}
        onOpenChange={setIsAddExpenseOpen}
        onAddExpense={addExpense}
        categories={categories} 
      />

      <UpdateExpenseDialog
        isOpen={isUpdateExpenseOpen}
        onOpenChange={setIsUpdateExpenseOpen}
        expense={currentExpense}
        onUpdateExpense={updateExpense}
        categories={categories} 
      />
    </div>
  )
}