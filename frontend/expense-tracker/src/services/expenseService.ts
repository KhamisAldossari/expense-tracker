import { axiosInstance } from '@/lib/axios';
import { 
  Expense, 
  ExpenseResponse, 
  Category, 
  ExpenseCreateUpdatePayload 
} from '@/types/expense';
import { mockExpenseService, mockCategoriesService } from './mockExpenseService';
// Flag to switch between mock and real services
const USE_MOCK = false ;

export const expenseService = USE_MOCK ? mockExpenseService : {
  async getExpenses(): Promise<Expense[]> {
    try {
      console.log('[Expenses] Fetching expenses');
      const { data } = await axiosInstance.get<ExpenseResponse>('/expenses');
      console.log('[Expenses] Successfully fetched expenses:', data.data);
      return data.data;
    } catch (error) {
      console.error('[Expenses] Failed to fetch expenses:', error);
      throw error;
    }
  },

  async addExpense(expense: ExpenseCreateUpdatePayload): Promise<Expense> {
    try {
      console.log('[Expenses] Adding new expense:', expense);
      const { data } = await axiosInstance.post<Expense>('/expenses', expense);
      console.log('[Expenses] Successfully added expense:', data);
      return data;
    } catch (error) {
      console.error('[Expenses] Failed to add expense:', error);
      throw error;
    }
  },

  async updateExpense(id: number, expense: ExpenseCreateUpdatePayload): Promise<Expense> {
    try {
      console.log('[Expenses] Updating expense:', id, expense);
      const { data } = await axiosInstance.put<Expense>(`/expenses/${id}`, expense);
      console.log('[Expenses] Successfully updated expense:', data);
      return data;
    } catch (error) {
      console.error('[Expenses] Failed to update expense:', error);
      throw error;
    }
  },

  async deleteExpense(id: number): Promise<void> {
    try {
      console.log('[Expenses] Deleting expense:', id);
      await axiosInstance.delete(`/expenses/${id}`);
      console.log('[Expenses] Successfully deleted expense:', id);
    } catch (error) {
      console.error('[Expenses] Failed to delete expense:', error);
      throw error;
    }
  }
};

export const categoriesService = USE_MOCK ? mockCategoriesService : {

  async getCategories(): Promise<Category[]> {
    try {
      console.log('[Categories] Fetching categories');
      const { data } = await axiosInstance.get<Category[]>('/categories');
      console.log('[Categories] Successfully fetched categories:', data);
      return data;
    } catch (error) {
      console.error('[Categories] Failed to fetch categories:', error);
      throw error;
    }
  }
}

