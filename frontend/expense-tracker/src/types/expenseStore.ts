import { Expense } from '../types/expense';
import { ExpenseFilters } from '../types/expenseFilters';

export interface ExpenseStore {
    // State
    expenses: Expense[];
    categories: string[];
    filters: ExpenseFilters;
    isLoading: boolean;
    error: string | null;
    editingExpense: Expense | null;
    token: string;
  

    // Fetch Actions
    fetchExpenses: () => Promise<void>;
    fetchCategories: () => Promise<void>;

    // CRUD Actions
    addExpense: (expense: Omit<Expense, 'id'>) => Promise<void>;
    updateExpense: (id: number, expense: Partial<Expense>) => Promise<void>;
    deleteExpense: (id: number) => Promise<void>;
    
    // UI Actions
    setEditingExpense: (expense: Expense | null) => void;
    setFilters: (filters: Partial<ExpenseFilters>) => void;
    clearError: () => void;
  
    // Computed
    getFilteredExpenses: () => Expense[];
    getTotalExpenses: () => number;
    // getMonthlyExpenses: () => number;
  }