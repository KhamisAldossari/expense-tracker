import { create } from 'zustand';
import { expenseService, categoriesService } from '@/services/expenseService';
import { Expense, Category, ExpenseCreateUpdatePayload } from '@/types/expense';

interface ExpenseStore {
  expenses: Expense[];
  categories: Category[];
  isLoading: boolean;
  error: string | null;
  fetchExpenses: () => Promise<void>;
  fetchCategories: () => Promise<void>;
  addExpense: (expense: Omit<Expense ,"id">&ExpenseCreateUpdatePayload) => Promise<void>;
  updateExpense: (id: number, expense: ExpenseCreateUpdatePayload) => Promise<void>;
  deleteExpense: (id: number) => Promise<void>;
  clearError: () => void;
}

export const useExpenseStore = create<ExpenseStore>((set, get) => ({
  expenses: [],
  categories: [],
  isLoading: false,
  error: null,

  fetchExpenses: async () => {
    set({ isLoading: true, error: null });
    try {
      const expenses = await expenseService.getExpenses();
      set({ expenses, isLoading: false });
    } catch (error: any) {
      const errorMessage = error.response?.data?.message || 'Failed to fetch expenses';
      console.error('[Store] fetchExpenses error:', errorMessage);
      set({ error: errorMessage, isLoading: false });
    }
  },

  fetchCategories: async () => {
    set({ isLoading: true, error: null });
    try {
      const categories = await categoriesService.getCategories() as Category[];
      set({ categories, isLoading: false });
    } catch (error: any) {
      const errorMessage = error.response?.data?.message || 'Failed to fetch categories';
      console.error('[Store] fetchCategories error:', errorMessage);
      set({ error: errorMessage, isLoading: false });
    }
  },

  addExpense: async (expense: Omit<Expense ,"id">&ExpenseCreateUpdatePayload ) => {
    set({ isLoading: true, error: null });
    try {
      const newExpense = await expenseService.addExpense(expense);
      set(state => ({
        expenses: [newExpense, ...state.expenses],
        isLoading: false
      }));
    } catch (error: any) {
      const errorMessage = error.response?.data?.message || 'Failed to add expense';
      console.error('[Store] addExpense error:', errorMessage);
      set({ error: errorMessage, isLoading: false });
      throw error; // Re-throw to handle in the UI
    }
  },

  updateExpense: async (id, expense) => {
    set({ isLoading: true, error: null });
    try {
      const updatedExpense = await expenseService.updateExpense(id, expense);
      set(state => ({
        expenses: state.expenses.map(e => e.id === id ? updatedExpense : e),
        isLoading: false
      }));
    } catch (error: any) {
      const errorMessage = error.response?.data?.message || 'Failed to update expense';
      console.error('[Store] updateExpense error:', errorMessage);
      set({ error: errorMessage, isLoading: false });
      throw error;
    }
  },

  deleteExpense: async (id) => {
    set({ isLoading: true, error: null });
    try {
      await expenseService.deleteExpense(id);
      set(state => ({
        expenses: state.expenses.filter(e => e.id !== id),
        isLoading: false
      }));
    } catch (error: any) {
      const errorMessage = error.response?.data?.message || 'Failed to delete expense';
      console.error('[Store] deleteExpense error:', errorMessage);
      set({ error: errorMessage, isLoading: false });
      throw error;
    }
  },

  clearError: () => set({ error: null })
}));