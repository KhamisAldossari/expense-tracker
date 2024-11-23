import { Button } from "@/components/common/button"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/common/dialog"
import { Input } from "@/components/common/input"
import { Label } from "@/components/common/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/common/select"
import { useEffect, useState } from "react"
import { Expense, Category, ExpenseCreateUpdatePayload } from '@/types/expense'

interface UpdateExpenseDialogProps {
  isOpen: boolean
  onOpenChange: (isOpen: boolean) => void
  expense: Expense | null
  onClose: () => void
  onSubmit: (id: number, expense: ExpenseCreateUpdatePayload) => Promise<void>
  categories: Category[]
}

export function UpdateExpenseDialog({ 
  isOpen, 
  onOpenChange, 
  expense, 
  onClose,
  onSubmit, 
  categories 
}: UpdateExpenseDialogProps) {
  const [updatedExpense, setUpdatedExpense] = useState<Expense | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [isSubmitting, setIsSubmitting] = useState(false)

  useEffect(() => {
    if (expense) {
      setUpdatedExpense(expense)
      setError(null)
    }
  }, [expense])

  const handleClose = () => {
    setUpdatedExpense(null)
    setError(null)
    setIsSubmitting(false)
    onClose()
  }

  const validateForm = () => {
    if (!updatedExpense) return false

    if (!updatedExpense.description.trim()) {
      setError('Description is required.')
      return false
    }
    if (!updatedExpense.category?.id) {
      setError('Please select a category.')
      return false
    }
    const amount = Number(updatedExpense.amount)
    if (!amount || amount <= 0 || isNaN(amount)) {
      setError('Please enter a valid amount.')
      return false
    }
    if (!updatedExpense.expense_date) {
      setError('Please select a date.')
      return false
    }
    return true
  }

  const handleUpdateExpense = async () => {
    if (!updatedExpense || !validateForm()) return

    setIsSubmitting(true)
    setError(null)

    try {
      // Only send the required fields in the update payload
      const updatePayload: ExpenseCreateUpdatePayload = {
        description: updatedExpense.description.trim(),
        category_id: updatedExpense.category.id,
        amount: Number(updatedExpense.amount),
        expense_date: updatedExpense.expense_date
      }

      console.log('Updating expense with payload:', updatePayload)
      await onSubmit(updatedExpense.id, updatePayload)
      handleClose()
    } catch (error) {
      console.error('Failed to update expense:', error)
      setError('Failed to update expense. Please try again.')
      setIsSubmitting(false)
    }
  }

  if (!updatedExpense) return null

  return (
    <Dialog 
      open={isOpen} 
      onOpenChange={(open) => {
        onOpenChange(open)
        if (!open) handleClose()
      }}
    >
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Update Expense</DialogTitle>
        </DialogHeader>
        <div className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="update-description" className="text-right">
              Description
            </Label>
            <Input
              id="update-description"
              value={updatedExpense.description}
              onChange={(e) => {
                setError(null)
                setUpdatedExpense(prev => prev ? {...prev, description: e.target.value} : null)
              }}
              className="col-span-3"
              placeholder="Enter expense description"
              disabled={isSubmitting}
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="update-category" className="text-right">
              Category
            </Label>
            <Select
              value={String(updatedExpense.category?.id)}
              onValueChange={(value) => {
                setError(null)
                const selectedCategory = categories.find(cat => String(cat.id) === value)
                if (selectedCategory && updatedExpense) {
                  setUpdatedExpense(prev => prev ? {...prev, category: selectedCategory} : null)
                }
              }}
              disabled={isSubmitting}
            >
              <SelectTrigger className="col-span-3">
                <SelectValue placeholder="Select category" />
              </SelectTrigger>
              <SelectContent>
                {categories.map((category) => (
                  <SelectItem 
                    key={category.id} 
                    value={String(category.id)}
                  >
                    {category.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="update-amount" className="text-right">
              Amount
            </Label>
            <Input
              id="update-amount"
              type="number"
              value={updatedExpense.amount}
              onChange={(e) => {
                setError(null)
                const value = e.target.value
                setUpdatedExpense(prev => prev ? {
                  ...prev, 
                  amount: value === '' ? 0 : parseFloat(value)
                } : null)
              }}
              className="col-span-3"
              placeholder="0.00"
              min="0"
              step="0.01"
              disabled={isSubmitting}
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="update-date" className="text-right">
              Date
            </Label>
            <Input
              id="update-date"
              type="date"
              value={updatedExpense.expense_date}
              onChange={(e) => {
                setError(null)
                setUpdatedExpense(prev => prev ? {...prev, expense_date: e.target.value} : null)
              }}
              className="col-span-3"
              max={new Date().toISOString().split('T')[0]}
              disabled={isSubmitting}
            />
          </div>
        </div>
        {error && (
          <p className="text-destructive text-sm mt-2 mb-4">{error}</p>
        )}
        <div className="flex justify-end gap-4">
          <Button 
            variant="outline" 
            onClick={handleClose}
            disabled={isSubmitting}
          >
            Cancel
          </Button>
          <Button 
            onClick={handleUpdateExpense}
            disabled={isSubmitting}
          >
            {isSubmitting ? 'Updating...' : 'Update Expense'}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  )
}