import { Card, CardContent, CardFooter } from "@/components/common/card"
import { Button } from "@/components/common/button"
import { Trash2, Edit } from 'lucide-react'
import { Expense } from '@/types/expense'

interface ExpenseListProps {
  expenses: Expense[]
  onUpdate: (expense: Expense) => void
  onDelete: (id: number) => void
}

export function ExpenseList({ expenses, onUpdate, onDelete }: ExpenseListProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      {expenses.map((expense) => (
        <Card key={expense.id} className="flex flex-col">
          <CardContent className="flex-grow p-4">
            <h2 className="text-xl font-semibold mb-2">{expense.description}</h2>
            <p className="text-sm text-muted-foreground mb-1">Category: {expense.category}</p>
            <p className="text-lg font-bold mb-1">${expense.amount.toFixed(2)}</p>
            <p className="text-sm text-muted-foreground">Date: {expense.date}</p>
          </CardContent>
          <CardFooter className="flex justify-between p-4">
            <Button variant="outline" size="sm" onClick={() => onUpdate(expense)}>
              <Edit className="w-4 h-4 mr-2" />
              Update
            </Button>
            <Button variant="destructive" size="sm" onClick={() => onDelete(expense.id)}>
              <Trash2 className="w-4 h-4 mr-2" />
              Delete
            </Button>
          </CardFooter>
        </Card>
      ))}
    </div>
  )
}