import { create } from 'zustand';
import { categoriesService, expenseService } from '../services/expenseService';
import { ExpenseStore } from '../types/expenseStore';

export const useExpenseStore = create<ExpenseStore>((set, get) => ({
  expenses: [],
  categories: [],
  filters: {
    category: 'all',
    searchTerm: '',
  },
  isLoading: false,
  error: null,
  editingExpense: null,

  fetchExpenses: async () => {
    set({ isLoading: true, error: null });
    try {
      const expenses = await expenseService.getExpenses();
      set({ expenses, isLoading: false });
    } catch (error) {
      set({ error: 'Failed to fetch expenses', isLoading: false });
    }
  },
  
  fetchCategories: async () => {
    set({ isLoading: true, error: null });
    try {
      const categories = await categoriesService.getCategories();
      set({ categories, isLoading: false });
    } catch (error) {
      set({ error: 'Failed to fetch categories', isLoading: false });
    }
  },

  addExpense: async (expense) => {
    set({ isLoading: true, error: null });
    try {
      const newExpense = await expenseService.addExpense(expense);
      set(state => ({
        expenses: [newExpense, ...state.expenses],
        isLoading: false
      }));
    } catch (error) {
      set({ error: 'Failed to add expense', isLoading: false });
    }
  },

  updateExpense: async (id, expense) => {
    set({ isLoading: true, error: null });
    try {
      const updatedExpense = await expenseService.updateExpense(id, expense);
      set(state => ({
        expenses: state.expenses.map(e => e.id === id ? updatedExpense : e),
        editingExpense: null,
        isLoading: false
      }));
    } catch (error) {
      set({ error: 'Failed to update expense', isLoading: false });
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
    } catch (error) {
      set({ error: 'Failed to delete expense', isLoading: false });
    }
  },

  setEditingExpense: (expense) => {
    set({ editingExpense: expense });
  },

  setFilters: (newFilters) => {
    set(state => ({
      filters: { ...state.filters, ...newFilters }
    }));
  },

  clearError: () => {
    set({ error: null });
  },

  getFilteredExpenses: () => {
    const { expenses, filters } = get();
    return expenses.filter(expense => {
      const matchesCategory = filters.category === 'all' || 
                            expense.category === filters.category;
      const matchesSearch = expense.description
        .toLowerCase()
        .includes(filters.searchTerm.toLowerCase());
      return matchesCategory && matchesSearch;
    });
  },

  getTotalExpenses: () => {
    return get().expenses.reduce((sum, exp) => sum + exp.amount, 0);
  },

  // getMonthlyExpenses: () => {
  //   const currentMonth = new Date().getMonth();
  //   return get().expenses
  //     .filter(exp => new Date(exp.date).getMonth() === currentMonth)
  //     .reduce((sum, exp) => sum + exp.amount, 0);
  // }

}));