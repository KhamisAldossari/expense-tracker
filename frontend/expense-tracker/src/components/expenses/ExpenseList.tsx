import { Card, CardContent, CardFooter } from "@/components/common/card"
import { Button } from "@/components/common/button"
import { Trash2, Edit, AlertCircle } from 'lucide-react'
import { Expense } from '@/types/expense'
import { Alert, AlertDescription } from "@/components/common/alert"

interface ExpenseListProps {
  expenses: Expense[]
  onUpdate: (expense: Expense) => void
  onDelete: (id: number) => void
}

export function ExpenseList({ expenses, onUpdate, onDelete }: ExpenseListProps) {
  // Format currency
  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount)
  }

  // Format date
  const formatExpenseDate = (date: string) => {
    return new Date(date).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    })
  }

  // Handle empty state
  if (!expenses.length) {
    return (
      <Alert>
        <AlertCircle className="h-4 w-4" />
        <AlertDescription>
          No expenses found. Start by adding a new expense.
        </AlertDescription>
      </Alert>
    )
  }

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      {expenses.map((expense) => (
        <Card 
          key={expense.id} 
          className="flex flex-col hover:shadow-md transition-shadow duration-200"
        >
          <CardContent className="flex-grow p-4">
            <div className="flex justify-between items-start mb-2">
              <h2 className="text-xl font-semibold line-clamp-2">
                {expense.description}
              </h2>
            </div>
            
            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">Category</span>
                <span className="font-medium">
                  {expense.category?.name || 'Uncategorized'}
                </span>
              </div>

              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">Amount</span>
                <span className="text-lg font-bold">
                  {formatCurrency(Number(expense.amount))}
                </span>
              </div>

              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">Date</span>
                <span className="font-medium">
                  {formatExpenseDate(expense.expense_date)}
                </span>
              </div>
            </div>
          </CardContent>

          <CardFooter className="flex justify-between p-4 border-t">
            <Button 
              variant="outline" 
              size="sm" 
              onClick={() => onUpdate(expense)}
              className="flex-1 mr-2"
            >
              <Edit className="w-4 h-4 mr-2" />
              Update
            </Button>
            <Button 
              variant="destructive" 
              size="sm" 
              onClick={() => {
                if (window.confirm('Are you sure you want to delete this expense?')) {
                  onDelete(expense.id)
                }
              }}
              className="flex-1 ml-2"
            >
              <Trash2 className="w-4 h-4 mr-2" />
              Delete
            </Button>
          </CardFooter>
        </Card>
      ))}
    </div>
  )
}