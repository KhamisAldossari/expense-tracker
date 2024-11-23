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
import { Skeleton } from "@/components/common/skeleton"
import { Plus, Search, SortAsc, SortDesc } from 'lucide-react'
import { Category } from '@/types/expense'
import { cn } from '@/lib/utils'

type SortByOption = 'expense_date' | 'amount'
type SortOrder = 'asc' | 'desc'

interface ExpenseFiltersProps {
  filters: {
    searchTerm: string
    categoryFilter: number | 'all'
    sortBy: SortByOption
    sortOrder: SortOrder
  }
  categories: {
    data: Category[]
  }
  isLoadingCategories: boolean
  onSearchChange: (value: string) => void
  onCategoryChange: (value: number | 'all') => void
  onSortByChange: (value: SortByOption) => void
  onSortOrderChange: (value: SortOrder) => void
  onAddExpense: () => void
  className?: string
}

export function ExpenseFilters({
  filters,
  categories,
  isLoadingCategories,
  onSearchChange,
  onCategoryChange,
  onSortByChange,
  onSortOrderChange,
  onAddExpense,
  className
}: ExpenseFiltersProps) {
  const categoriesArray = useMemo(() => {
    return categories.data?.map(category => ({
      id: category.id,
      name: category.name
    })) || []
  }, [categories])
  
  const sortOptions = useMemo(() => [
    { value: 'expense_date', label: 'Date' },
    { value: 'amount', label: 'Amount' }
  ] as const, [])

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
      <div className="flex flex-col sm:flex-row gap-4 flex-grow">
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

        {isLoadingCategories ? (
          <Skeleton className="h-10 w-[200px]" />
        ) : (
          <Select
            value={String(filters.categoryFilter)}
            onValueChange={handleCategoryChange}
          >
            <SelectTrigger className="w-full sm:w-[200px]">
              <SelectValue placeholder="Select category" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All Categories</SelectItem>
              {categoriesArray.length > 0 ? (
                categoriesArray.map((category) => (
                  <SelectItem 
                    key={category.id}
                    value={String(category.id)}
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
        )}
      </div>

      <div className="flex items-center gap-2 justify-end">
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