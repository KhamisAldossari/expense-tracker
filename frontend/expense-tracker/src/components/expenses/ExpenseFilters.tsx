import { Button } from "@/components/common/button"
import { Input } from "@/components/common/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/common/select"
import { Plus, Search, ArrowUpDown } from 'lucide-react'
import categories from './ExpenseTracker'

interface ExpenseFiltersProps {
  searchTerm: string
  setSearchTerm: (term: string) => void
  categoryFilter: string
  setCategoryFilter: (category: string) => void
  sortBy: 'date' | 'amount'
  setSortBy: (sort: 'date' | 'amount') => void
  sortOrder: 'asc' | 'desc'
  setSortOrder: (order: 'asc' | 'desc') => void
  setIsAddExpenseOpen: (isOpen: boolean) => void
  categories : string[]
}

export function ExpenseFilters({
  searchTerm,
  setSearchTerm,
  categoryFilter,
  setCategoryFilter,
  sortBy,
  setSortBy,
  sortOrder,
  setSortOrder,
  setIsAddExpenseOpen,
  categories
}: ExpenseFiltersProps) {
  const allCategories = ['all', ...categories.map(c => c.toLowerCase())]

  return (
    <div className="flex flex-col md:flex-row justify-between items-center mb-4 gap-4">
      <div className="flex flex-col md:flex-row items-center gap-4 w-full md:w-auto">
        <div className="relative flex-grow md:flex-grow-0 md:w-64">
          <Search className="absolute left-2 top-1/2 transform -translate-y-1/2 text-gray-400" />
          <Input
            type="text"
            placeholder="Search expenses..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10"
          />
        </div>
        <Select value={categoryFilter} onValueChange={setCategoryFilter}>
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Select category" />
          </SelectTrigger>
          <SelectContent>
            {allCategories.map((category) => (
              <SelectItem key={category} value={category}>
                {category === 'all' ? 'All' : category.charAt(0).toUpperCase() + category.slice(1)}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>
      <div className="flex items-center gap-2">
        <Select value={sortBy} onValueChange={(value: 'date' | 'amount') => setSortBy(value)}>
          <SelectTrigger className="w-[120px]">
            <SelectValue placeholder="Sort by" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="date">Date</SelectItem>
            <SelectItem value="amount">Amount</SelectItem>
          </SelectContent>
        </Select>
        <Button
          variant="outline"
          size="icon"
          onClick={() => setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc')}
          aria-label={`Sort ${sortOrder === 'asc' ? 'descending' : 'ascending'}`}
        >
          <ArrowUpDown className={`h-4 w-4 ${sortOrder === 'asc' ? 'rotate-180' : ''}`} />
        </Button>
      </div>
      <Button onClick={() => setIsAddExpenseOpen(true)}>
        <Plus className="w-4 h-4 mr-2" />
        Add Expense
      </Button>
    </div>
  )
}