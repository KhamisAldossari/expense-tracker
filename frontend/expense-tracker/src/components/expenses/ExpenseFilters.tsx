import { useCallback, useMemo } from 'react'
import { Button } from "@/components/common/button"
import { Input } from "@/components/common/input"
import { 
  Select, 
  SelectContent, 
  SelectItem, 
  SelectTrigger, 
  SelectValue 
} from "@/components/common/select"
import { Plus, Search, ArrowUpDown, SortAsc, SortDesc } from 'lucide-react'
import { Category } from '@/types/expense'
import { cn } from '@/lib/utils'

interface ExpenseFiltersProps {
  filters: {
    searchTerm: string
    categoryFilter: number | 'all'
    sortBy: 'expense_date' | 'amount'
    sortOrder: 'asc' | 'desc'
  }
  categories: Category[] | undefined
  onSearchChange: (value: string) => void
  onCategoryChange: (value: number | 'all') => void
  onSortByChange: (value: 'expense_date' | 'amount') => void
  onSortOrderChange: (value: 'asc' | 'desc') => void
  onAddExpense: () => void
  className?: string
}

export function ExpenseFilters({
  filters,
  categories,
  onSearchChange,
  onCategoryChange,
  onSortByChange,
  onSortOrderChange,
  onAddExpense,
  className
}: ExpenseFiltersProps) {
  // Memoized derived data
  const sortOptions = useMemo(() => [
    { value: 'expense_date', label: 'Date' },
    { value: 'amount', label: 'Amount' }
  ] as const, [])

  // Memoized event handlers
  const handleSearchChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    onSearchChange(e.target.value)
  }, [onSearchChange])

  const handleCategoryChange = useCallback((value: string) => {
    onCategoryChange(value === 'all' ? 'all' : parseInt(value))
  }, [onCategoryChange])

  const handleSortChange = useCallback((value: string) => {
    onSortByChange(value as 'expense_date' | 'amount')
  }, [onSortByChange])

  const toggleSortOrder = useCallback(() => {
    onSortOrderChange(filters.sortOrder === 'asc' ? 'desc' : 'asc')
  }, [filters.sortOrder, onSortOrderChange])

  return (
    <div className={cn(
      "grid gap-4 p-4 bg-background rounded-lg border",
      "sm:flex sm:flex-wrap sm:items-center sm:justify-between",
      className
    )}>
      {/* Search and Category Filters */}
      <div className="flex flex-col sm:flex-row gap-4 flex-grow">
        {/* Search Input */}
        <div className="relative flex-grow max-w-md">
          <Search 
            className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" 
            aria-hidden="true"
          />
          <Input
            type="search"
            placeholder="Search expenses..."
            value={filters.searchTerm}
            onChange={handleSearchChange}
            className="pl-9"
            aria-label="Search expenses"
          />
        </div>

        {/* Category Filter */}
        <Select
          value={String(filters.categoryFilter)}
          onValueChange={handleCategoryChange}
        >
          <SelectTrigger className="w-full sm:w-[200px]">
            <SelectValue placeholder="Select category" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Categories</SelectItem>
            {Array.isArray(categories) && categories.map((category: Category) => (
              <SelectItem 
                key={category.id} 
                value={String(category.id)}
              >
                {category.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {/* Sort Controls and Add Button */}
      <div className="flex items-center gap-2 justify-end">
        {/* Sort By */}
        <Select
          value={filters.sortBy}
          onValueChange={handleSortChange}
        >
          <SelectTrigger className="w-[130px]">
            <SelectValue placeholder="Sort by" />
          </SelectTrigger>
          <SelectContent>
            {sortOptions.map(option => (
              <SelectItem 
                key={option.value} 
                value={option.value}
              >
                {option.label}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>

        {/* Sort Order Toggle */}
        <Button
          variant="outline"
          size="icon"
          onClick={toggleSortOrder}
          aria-label={`Sort ${filters.sortOrder === 'asc' ? 'descending' : 'ascending'}`}
        >
          {filters.sortOrder === 'asc' ? (
            <SortAsc className="h-4 w-4" />
          ) : (
            <SortDesc className="h-4 w-4" />
          )}
        </Button>

        {/* Add Expense Button */}
        <Button 
          onClick={onAddExpense}
          className="whitespace-nowrap"
        >
          <Plus className="w-4 h-4 mr-2" aria-hidden="true" />
          Add Expense
        </Button>
      </div>
    </div>
  )
}