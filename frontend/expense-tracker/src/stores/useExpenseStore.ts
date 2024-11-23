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
  addExpense: (expense: Omit<Expense, "id"> & ExpenseCreateUpdatePayload) => Promise<void>;
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
    try {
      set({ isLoading: true, error: null });
      const expenses = await expenseService.getExpenses();
      console.log('Fetched expenses:', expenses);
      set({ expenses, isLoading: false });
    } catch (error: any) {
      const errorMessage = error.response?.data?.message || 'Failed to fetch expenses';
      console.error('[Store] fetchExpenses error:', errorMessage);
      set({ error: errorMessage, isLoading: false });
    }
  },
  fetchCategories: async () => {
    try {
      set({ isLoading: true, error: null });
      const response = await categoriesService.getCategories() as Category[] | { data: Category[] };
      console.log('Raw Categories Response:', response); // Debug log
  
      const categories = Array.isArray(response) ? response : response.data ? response.data : [];
  
      console.log('Processed Categories:', categories); 
  
      set(state => {
        console.log('Previous state:', state.categories);
        const newState = { 
          categories: categories,
          isLoading: false 
        };
        console.log('New state:', newState.categories);
        return newState;
      });
    } catch (error: any) {
      const errorMessage = error.response?.data?.message || 'Failed to fetch categories';
      console.error('[Store] fetchCategories error:', error);
      set({ error: errorMessage, isLoading: false });
    }
  },

  addExpense: async (expenseData: Omit<Expense, "id"> & ExpenseCreateUpdatePayload) => {
    const currentState = get();
    try {
      set({ isLoading: true, error: null });
      console.log('Adding expense with data:', expenseData);

      const newExpense = await expenseService.addExpense(expenseData);
      console.log('Received new expense:', newExpense);

      // Find the complete category object
      const category = currentState.categories.find(c => c.id === expenseData.category_id);
      
      if (!category) {
        throw new Error('Category not found');
      }

      // Construct the complete expense object
      const completeExpense: Expense = {
        ...newExpense,
        category
      };

      console.log('Complete expense object:', completeExpense);

      set(state => ({
        expenses: [completeExpense, ...state.expenses],
        isLoading: false
      }));
    } catch (error: any) {
      const errorMessage = error.response?.data?.message || 'Failed to add expense';
      console.error('[Store] addExpense error:', errorMessage, error);
      set({ error: errorMessage, isLoading: false });
      throw error;
    }
  },

  updateExpense: async (id: number, expenseData: ExpenseCreateUpdatePayload) => {
    const currentState = get();
    try {
      set({ isLoading: true, error: null });
      console.log('Updating expense:', id, expenseData);

      const updatedExpense = await expenseService.updateExpense(id, expenseData);
      console.log('Received updated expense:', updatedExpense);

      // Find the complete category object
      const category = currentState.categories.find(c => c.id === expenseData.category_id);
      
      if (!category) {
        throw new Error('Category not found');
      }

      // Construct the complete expense object
      const completeExpense: Expense = {
        ...updatedExpense,
        category
      };

      console.log('Complete updated expense:', completeExpense);

      set(state => ({
        expenses: state.expenses.map(e => e.id === id ? completeExpense : e),
        isLoading: false
      }));
    } catch (error: any) {
      const errorMessage = error.response?.data?.message || 'Failed to update expense';
      console.error('[Store] updateExpense error:', errorMessage, error);
      set({ error: errorMessage, isLoading: false });
      throw error;
    }
  },

  deleteExpense: async (id: number) => {
    try {
      set({ isLoading: true, error: null });
      console.log('Deleting expense:', id);

      await expenseService.deleteExpense(id);
      
      set(state => {
        const newExpenses = state.expenses.filter(e => e.id !== id);
        console.log('Updated expenses after delete:', newExpenses);
        return {
          expenses: newExpenses,
          isLoading: false
        };
      });
    } catch (error: any) {
      const errorMessage = error.response?.data?.message || 'Failed to delete expense';
      console.error('[Store] deleteExpense error:', errorMessage);
      set({ error: errorMessage, isLoading: false });
      throw error;
    }
  },

  clearError: () => set({ error: null })
}));