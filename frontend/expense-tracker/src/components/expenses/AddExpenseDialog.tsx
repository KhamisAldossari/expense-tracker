import { Button } from "@/components/common/button"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/common/dialog"
import { Input } from "@/components/common/input"
import { Label } from "@/components/common/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/common/select"
import { useState } from "react"
import { Expense, ExpenseCreateUpdatePayload } from '@/types/expense'
import { Category } from '@/types/expense'

interface AddExpenseDialogProps {
  isOpen: boolean
  onOpenChange: (isOpen: boolean) => void
  onAddExpense: (expense: Omit<Expense, 'id'>) => void
  onClose: () => void

  onSubmit: (newExpense: Omit<Expense, 'id'> & ExpenseCreateUpdatePayload) => Promise<void>
  categories: Category[]
}

export function AddExpenseDialog({ isOpen, onOpenChange, onAddExpense, categories }: AddExpenseDialogProps) {
  const [newExpense, setNewExpense] = useState<Omit<Expense, 'id'>>({
    description: '',
    category: {} as Category,
    amount: 0,
    expense_date: new Date().toISOString().split('T')[0],
    created_at: new Date().toISOString(),
  })

  const handleAddExpense = () => {
    if (newExpense.description && newExpense.category.name && newExpense.amount > 0) {
      setNewExpense({
        description: '',
        category: {} as Category,
        amount: 0,
        expense_date: new Date().toISOString().split('T')[0],
        created_at: new Date().toISOString(),
      })
      onOpenChange(false)
    }
  }

  return (
    <Dialog open={isOpen} onOpenChange={onOpenChange}>
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
              onChange={(e) => setNewExpense({...newExpense, description: e.target.value})}
              className="col-span-3"
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="category" className="text-right">
              Category
            </Label>
            <Select
              value={newExpense.category.name}
              onValueChange={(value) => {
                const selectedCategory = categories.find(category=> category.name === value)
                if (selectedCategory) {
                  setNewExpense({...newExpense, category: selectedCategory})
                }
              }}
            >
              <SelectTrigger className="col-span-3">
                <SelectValue placeholder="Select category" />
              </SelectTrigger>
              <SelectContent>
                {Array.isArray(categories) && categories.slice(1).map((category: Category) => (
                  <SelectItem key={category.id} value={category.name}>
                    {category.name}
                  </SelectItem>
                ))}
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
              onChange={(e) => setNewExpense({...newExpense, amount: parseFloat(e.target.value)})}
              className="col-span-3"
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
              onChange={(e) => setNewExpense({...newExpense, expense_date: e.target.value})}
              className="col-span-3"
            />
          </div>
        </div>
        <Button onClick={handleAddExpense}>Add Expense</Button>
      </DialogContent>
    </Dialog>
  )
}