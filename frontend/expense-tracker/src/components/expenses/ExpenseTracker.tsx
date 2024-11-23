"use client"

import { useState, useCallback, useEffect } from 'react'
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
    error,
    fetchExpenses
  } = useExpenses()

  const [localExpenses, setLocalExpenses] = useState(expenses)

  useEffect(() => {
    setLocalExpenses(expenses)
  }, [expenses])

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
      await fetchExpenses() // Refetch expenses after adding
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
  }, [addExpense, fetchExpenses, toast])

  const handleUpdateExpense = useCallback(async (id: number, expense: ExpenseCreateUpdatePayload) => {
    try {
      await updateExpense(id, expense)
      handleCloseUpdateDialog()
      await fetchExpenses() // Refetch expenses after updating
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
  }, [updateExpense, fetchExpenses, toast])

  const handleDeleteExpense = useCallback(async (id: number) => {
    if (!window.confirm('Are you sure you want to delete this expense?')) return

    try {
      await deleteExpense(id)
      await fetchExpenses() // Refetch expenses after deleting
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
  }, [deleteExpense, fetchExpenses, toast])

  // Handler for category filter change
  const handleCategoryFilterChange = useCallback(async (category: number | "all") => {
      setCategoryFilter(category)
      await fetchExpenses() // Refetch expenses after changing the filter
    }, [setCategoryFilter, fetchExpenses])

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
        onCategoryChange={handleCategoryFilterChange}
        onSortByChange={setSortBy}
        onSortOrderChange={setSortOrder}
        onAddExpense={handleOpenAddDialog}
      />

      {/* Expense list */}
      <ExpenseList
        expenses={localExpenses}
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

