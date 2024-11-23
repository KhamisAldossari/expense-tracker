import { Button } from "@/components/common/button"
import { Dialog, DialogContent, DialogHeader, DialogTitle} from "@/components/common/dialog"
import { Input } from "@/components/common/input"
import { Label } from "@/components/common/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/common/select"
import { useEffect, useState } from "react"
import { Expense, ExpenseCreateUpdatePayload } from '@/types/expense'
import { Category } from '@/types/expense'

interface AddExpenseDialogProps {
  isOpen: boolean
  onOpenChange: (isOpen: boolean) => void
  onClose: () => void
  onSubmit: (newExpense: Omit<Expense, 'id'> & ExpenseCreateUpdatePayload) => Promise<void>
  categories:Category[] | []
}

export function AddExpenseDialog({ 
  isOpen, 
  onOpenChange, 
  onClose, 
  onSubmit, 
  categories 
}: AddExpenseDialogProps) {
  // Initialize state function
  const getInitialState = () => ({
    description: '',
    category: null as Category | null,
    amount: '',
    expense_date: new Date().toISOString().split('T')[0],
    created_at: new Date().toISOString(),
  })

  const [newExpense, setNewExpense] = useState(getInitialState())
  const [error, setError] = useState<string | null>(null)
  const [isSubmitting, setIsSubmitting] = useState(false)


  useEffect(() => {
    if (!isOpen) {
      setNewExpense(getInitialState())
      setError(null)
      setIsSubmitting(false)
    }
  }, [isOpen])

  const handleClose = () => {
    setNewExpense(getInitialState())
    setError(null)
    setIsSubmitting(false)
    onClose()
  }

  const validateForm = () => {
    if (!newExpense.description.trim()) {
      setError('Description is required.')
      return false
    }
    if (!newExpense.category?.id) {
      setError('Please select a category.')
      return false
    }
    const amount = Number(newExpense.amount)
    if (!amount || amount <= 0 || isNaN(amount)) {
      setError('Please enter a valid amount.')
      return false
    }
    if (!newExpense.expense_date) {
      setError('Please select a date.')
      return false
    }
    return true
  }

  const handleAddExpense = async () => {
    if (!validateForm()) return

    setIsSubmitting(true)
    setError(null)

    try {
      const amount = Number(newExpense.amount)
      if (!newExpense.category) throw new Error('Category is required')

      await onSubmit({
        description: newExpense.description.trim(),
        category_id: newExpense.category.id,
        category: newExpense.category,
        amount,
        expense_date: newExpense.expense_date,
        created_at: newExpense.created_at
      })
      handleClose()
    } catch (error) {
      setError('Failed to add expense. Please try again.')
      setIsSubmitting(false)
    }
  }

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
          <DialogTitle>Add New Expense</DialogTitle>
        </DialogHeader>
        <div className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="description" className="text-right">
              Description
            </Label>
            <Input
              id="description"
              value={newExpense.description}
              onChange={(e) => {
                setError(null)
                setNewExpense(prev => ({...prev, description: e.target.value}))
              }}
              className="col-span-3"
              placeholder="Enter expense description"
              disabled={isSubmitting}
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="category" className="text-right">
              Category
            </Label>
            <Select
              value={newExpense.category?.id?.toString() || ''}
              onValueChange={(value) => {
                setError(null)
                const selectedCategory = categories.find(cat => cat.id.toString() === value)
                setNewExpense(prev => ({
                  ...prev,
                  category: selectedCategory || null
                }))
              }}
              disabled={isSubmitting}
            >
              <SelectTrigger className="col-span-3">
                <SelectValue placeholder="Select category" />
              </SelectTrigger>
              <SelectContent>
                {categories.length > 0 ? (
                  categories.map((category) => (
                    <SelectItem 
                      key={category.id}
                      value={category.id.toString()}
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
            <Label htmlFor="amount" className="text-right">
              Amount
            </Label>
            <Input
              id="amount"
              type="number"
              value={newExpense.amount}
              onChange={(e) => {
                setError(null)
                const value = e.target.value
                setNewExpense(prev => ({...prev, amount: value}))
              }}
              className="col-span-3"
              placeholder="0.00"
              min="0"
              step="0.01"
              disabled={isSubmitting}
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="date" className="text-right">
              Date
            </Label>
            <Input
              id="date"
              type="date"
              value={newExpense.expense_date}
              onChange={(e) => {
                setError(null)
                setNewExpense(prev => ({...prev, expense_date: e.target.value}))
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
            onClick={handleAddExpense}
            disabled={isSubmitting}
          >
            {isSubmitting ? 'Adding...' : 'Add Expense'}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  )
}