// src/components/expenses/ExpenseTracker.tsx
"use client"

import { useState, useCallback } from 'react'
import { useExpenses } from '@/stores/useExpenses'
import { Expense, ExpenseCreateUpdatePayload } from '@/types/expense'
import { ExpenseDashboard } from './ExpenseDashboard'
import { ExpenseFilters } from './ExpenseFilters'
import { ExpenseList } from './ExpenseList'
import { AddExpenseDialog } from '@/components/expenses/AddExpenseDialog'
import { UpdateExpenseDialog } from '@/components/expenses/UpdateExpenseDialog'
import { Alert, AlertDescription } from '@/components/common/alert'
import { LoadingSpinner } from '@/components/common/loading-spinner'
import { useToast } from '@/components/common/use-toast'

export default function ExpenseTracker() {
  // Custom hook for expense management
  const {
    expenses,
    categories,
    totals,
    filters,
    setSearchTerm,
    setCategoryFilter,
    setSortBy,
    setSortOrder,
    addExpense,
    updateExpense,
    deleteExpense,
    isLoading,
    error
  } = useExpenses()

  // Wrap categories in the expected format
  const categoriesData = { data: categories }

  // Local state for dialogs
  const [dialogState, setDialogState] = useState<{
    isAddOpen: boolean
    isUpdateOpen: boolean
    currentExpense: Expense | null
  }>({
    isAddOpen: false,
    isUpdateOpen: false,
    currentExpense: null
  })

  // Toast notifications
  const { toast } = useToast()

  // Dialog handlers
  const handleOpenAddDialog = useCallback(() => {
    setDialogState(prev => ({ ...prev, isAddOpen: true }))
  }, [])

  const handleCloseAddDialog = useCallback(() => {
    setDialogState(prev => ({ ...prev, isAddOpen: false }))
  }, [])

  const handleOpenUpdateDialog = useCallback((expense: Expense) => {
    setDialogState(prev => ({
      ...prev,
      isUpdateOpen: true,
      currentExpense: expense
    }))
  }, [])

  const handleCloseUpdateDialog = useCallback(() => {
    setDialogState(prev => ({
      ...prev,
      isUpdateOpen: false,
      currentExpense: null
    }))
  }, [])

  // CRUD operation handlers with notifications
  const handleAddExpense = useCallback(async (newExpense: Omit<Expense, 'id'>&ExpenseCreateUpdatePayload) => {
    try {
      await addExpense(newExpense)
      handleCloseAddDialog()
      toast({
        title: "Success",
        description: "Expense added successfully",
        variant: "default"
      })
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to add expense. Please try again.",
        variant: "destructive"
      })
    }
  }, [addExpense, toast])

  const handleUpdateExpense = useCallback(async (id: number, expense: Omit<Expense, 'id'>&ExpenseCreateUpdatePayload) => {
    try {
      await updateExpense(id, expense)
      handleCloseUpdateDialog()
      toast({
        title: "Success",
        description: "Expense updated successfully",
        variant: "default"
      })
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to update expense. Please try again.",
        variant: "destructive"
      })
    }
  }, [updateExpense, toast])

  const handleDeleteExpense = useCallback(async (id: number) => {
    if (!window.confirm('Are you sure you want to delete this expense?')) return

    try {
      await deleteExpense(id)
      toast({
        title: "Success",
        description: "Expense deleted successfully",
        variant: "default"
      })
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to delete expense. Please try again.",
        variant: "destructive"
      })
    }
  }, [deleteExpense, toast])

  // Loading state
  if (isLoading) {
    return (
      <div className="container mx-auto p-4 flex justify-center items-center min-h-[400px]">
        <LoadingSpinner />
      </div>
    )
  }

  // Error state
  if (error) {
    return (
      <div className="container mx-auto p-4">
        <Alert variant="destructive">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      </div>
    )
  }

  return (
    <div className="container mx-auto p-4 space-y-6">
      {/* Dashboard showing totals and charts */}
      <ExpenseDashboard
        total={totals.total}
      />

      {/* Filters and sorting */}
      <ExpenseFilters
        filters={filters}
        categories={categories}
        isLoadingCategories={isLoading}
        onSearchChange={setSearchTerm}
        onCategoryChange={setCategoryFilter}
        onSortByChange={setSortBy}
        onSortOrderChange={setSortOrder}
        onAddExpense={handleOpenAddDialog}
      />

      {/* Expense list */}
      <ExpenseList
        expenses={expenses}
        onUpdate={handleOpenUpdateDialog}
        onDelete={handleDeleteExpense}
      />

      {/* Dialogs */}
      <AddExpenseDialog
        isOpen={dialogState.isAddOpen}
        onClose={handleCloseAddDialog}
        onSubmit={handleAddExpense}
        categories={categories}
        onOpenChange={handleOpenAddDialog}
      />

      <UpdateExpenseDialog
        isOpen={dialogState.isUpdateOpen}
        expense={dialogState.currentExpense}
        onClose={handleCloseUpdateDialog}
        onSubmit={handleUpdateExpense}
        categories={categories}
        onOpenChange={handleCloseUpdateDialog}
      />
    </div>
  )
}