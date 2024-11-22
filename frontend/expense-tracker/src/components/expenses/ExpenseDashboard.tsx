import { Card, CardContent, CardHeader, CardTitle } from "@/components/common/card"

interface ExpenseDashboardProps {
  total: number
}

export function ExpenseDashboard({ total }: ExpenseDashboardProps) {
  return (
    <Card className="mb-6">
      <CardHeader>
        <CardTitle>Expense Dashboard</CardTitle>
      </CardHeader>
      <CardContent>
        <p className="text-2xl font-bold">Total Spend: ${total.toFixed(2)}</p>
      </CardContent>
    </Card>
  )
}