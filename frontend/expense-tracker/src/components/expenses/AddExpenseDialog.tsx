import { Button } from "@/components/common/button"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/common/dialog"
import { Input } from "@/components/common/input"
import { Label } from "@/components/common/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/common/select"
import { useState } from "react"
import { Expense } from '@/types/expense'

interface AddExpenseDialogProps {
  isOpen: boolean
  onOpenChange: (isOpen: boolean) => void
  onAddExpense: (expense: Omit<Expense, 'id'>) => void
  categories: string[]
}

export function AddExpenseDialog({ isOpen, onOpenChange, onAddExpense, categories }: AddExpenseDialogProps) {
  const [newExpense, setNewExpense] = useState<Omit<Expense, 'id'>>({
    description: '',
    category: '',
    amount: 0,
    date: new Date().toISOString().split('T')[0],
  })

  const handleAddExpense = () => {
    if (newExpense.description && newExpense.category && newExpense.amount > 0) {
      onAddExpense(newExpense)
      setNewExpense({
        description: '',
        category: '',
        amount: 0,
        date: new Date().toISOString().split('T')[0]
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
              value={newExpense.category}
              onValueChange={(value) => setNewExpense({...newExpense, category: value})}
            >
              <SelectTrigger className="col-span-3">
                <SelectValue placeholder="Select category" />
              </SelectTrigger>
              <SelectContent>
                {categories.slice(1).map((category) => (
                  <SelectItem key={category} value={category}>
                    {category}
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
              value={newExpense.date}
              onChange={(e) => setNewExpense({...newExpense, date: e.target.value})}
              className="col-span-3"
            />
          </div>
        </div>
        <Button onClick={handleAddExpense}>Add Expense</Button>
      </DialogContent>
    </Dialog>
  )
}