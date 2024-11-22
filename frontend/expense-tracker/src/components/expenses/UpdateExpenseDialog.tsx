import { Button } from "@/components/common/button"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/common/dialog"
import { Input } from "@/components/common/input"
import { Label } from "@/components/common/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/common/select"
import { useEffect, useState } from "react"
import categories from './ExpenseTracker'
import { Expense, Category, ExpenseCreateUpdatePayload } from '@/types/expense'

interface UpdateExpenseDialogProps {
  isOpen: boolean
  onOpenChange: (isOpen: boolean) => void
  expense: Expense | null
  onUpdateExpense: (expense: Expense) => void
  onClose: () => void
  onSubmit: (id: number, expense: Omit<Expense, 'id'> & ExpenseCreateUpdatePayload) => Promise<void>
  categories: Category[]
}

export function UpdateExpenseDialog({ isOpen, onOpenChange, expense, onUpdateExpense, categories }: UpdateExpenseDialogProps) {
  const [updatedExpense, setUpdatedExpense] = useState<Expense | null>(null)

  useEffect(() => {
    if (expense) {
      setUpdatedExpense(expense)
    }
  }, [expense])

  const handleUpdateExpense = () => {
    if (updatedExpense) {
      onUpdateExpense(updatedExpense)
      onOpenChange(false)
    }
  }

  if (!updatedExpense) return null

  return (
    <Dialog open={isOpen} onOpenChange={onOpenChange}>
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
              onChange={(e) => setUpdatedExpense({...updatedExpense, description: e.target.value})}
              className="col-span-3"
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="update-category" className="text-right">
              Category
            </Label>
            <Select
              value={updatedExpense.category.name}
              onValueChange={(value) => {
                const selectedCategory = categories.find((category: Category) => category.name === value)
                if (selectedCategory) {
                  setUpdatedExpense({...updatedExpense, category: selectedCategory})
                }
              }}
            >
              <SelectTrigger className="col-span-3">
                <SelectValue placeholder="Select category" />
              </SelectTrigger>
              <SelectContent>
                {categories.slice(1).map((category) => (
                  <SelectItem key={category.id} value={category.name}>
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
              onChange={(e) => setUpdatedExpense({...updatedExpense, amount: parseFloat(e.target.value)})}
              className="col-span-3"
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
              onChange={(e) => setUpdatedExpense({...updatedExpense, expense_date: e.target.value})}
              className="col-span-3"
            />
          </div>
        </div>
        <Button onClick={handleUpdateExpense}>Update Expense</Button>
      </DialogContent>
    </Dialog>
  )
}