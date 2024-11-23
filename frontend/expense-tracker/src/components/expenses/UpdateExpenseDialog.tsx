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
  onSubmit: (id: number, expense: Omit<Expense, 'id'> & ExpenseCreateUpdatePayload) => Promise<void>
  categories: {
    data: Category[]
  }
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

  const categoriesArray = categories?.data || []

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
    if (!updatedExpense.amount || updatedExpense.amount <= 0) {
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
      await onSubmit(updatedExpense.id, {
        description: updatedExpense.description.trim(),
        category_id: updatedExpense.category.id,
        category: updatedExpense.category,
        amount: Number(updatedExpense.amount),
        expense_date: updatedExpense.expense_date,
        created_at: updatedExpense.created_at
      })
      handleClose()
    } catch (error) {
      setError('Failed to update expense. Please try again.')
    } finally {
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
                setUpdatedExpense({...updatedExpense, description: e.target.value})
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
              value={updatedExpense.category?.name || ''}
              onValueChange={(value) => {
                setError(null)
                const selectedCategory = categoriesArray.find(category => category.name === value)
                if (selectedCategory) {
                  setUpdatedExpense({...updatedExpense, category: selectedCategory})
                }
              }}
              disabled={isSubmitting}
            >
              <SelectTrigger className="col-span-3">
                <SelectValue placeholder="Select category" />
              </SelectTrigger>
              <SelectContent>
                {categoriesArray.length > 0 ? (
                  categoriesArray.map((category) => (
                    <SelectItem 
                      key={category.id} 
                      value={category.name}
                    >
                      {category.name}
                    </SelectItem>
                  ))
                ) : (
                  <SelectItem value="no-categories" disabled>
                    No categories available
                  </SelectItem>
                )}
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
              value={updatedExpense.amount || ''}
              onChange={(e) => {
                setError(null)
                setUpdatedExpense({...updatedExpense, amount: parseFloat(e.target.value) || 0})
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
                setUpdatedExpense({...updatedExpense, expense_date: e.target.value})
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