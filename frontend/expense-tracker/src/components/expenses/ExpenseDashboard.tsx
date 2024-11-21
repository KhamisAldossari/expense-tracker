import { Card, CardContent, CardHeader, CardTitle } from "@/components/common/card"

interface ExpenseDashboardProps {
  totalSpend: number
}

export function ExpenseDashboard({ totalSpend }: ExpenseDashboardProps) {
  return (
    <Card className="mb-6">
      <CardHeader>
        <CardTitle>Expense Dashboard</CardTitle>
      </CardHeader>
      <CardContent>
        <p className="text-2xl font-bold">Total Spend: ${totalSpend.toFixed(2)}</p>
      </CardContent>
    </Card>
  )
}