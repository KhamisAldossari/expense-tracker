import { Expense } from '@/types/expense';

// Mock initial data
const mockExpenses: Expense[] = [
  { id: 1, description: "Groceries", category: "food", amount: 50.25, date: "2024-03-01" },
  { id: 2, description: "Movie tickets", category: "entertainment", amount: 25.00, date: "2024-03-02" },
  { id: 3, description: "Gas", category: "transportation", amount: 40.50, date: "2024-03-03" },
  { id: 4, description: "Dinner out", category: "food", amount: 75.00, date: "2024-03-04" },
  { id: 5, description: "Books", category: "education", amount: 35.99, date: "2024-03-05" },
];

const mockCategories: string[] = [
  "food",
  "entertainment",
  "transportation",
  "education",
  "utilities",
  "healthcare",
  "shopping",
  "other"
];

// Simulate network delay
const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export const mockExpenseService = {
  async getExpenses(): Promise<Expense[]> {
    await delay(500); // Simulate network delay
    return [...mockExpenses]; // Return a copy to prevent mutation
  },

  async addExpense(expense: Omit<Expense, 'id'>): Promise<Expense> {
    await delay(500);
    const newExpense = {
      ...expense,
      id: Math.max(...mockExpenses.map(e => e.id)) + 1
    };
    mockExpenses.push(newExpense);
    return newExpense;
  },

  async updateExpense(id: number, expense: Partial<Expense>): Promise<Expense> {
    await delay(500);
    const index = mockExpenses.findIndex(e => e.id === id);
    if (index === -1) throw new Error('Expense not found');
    
    const updatedExpense = {
      ...mockExpenses[index],
      ...expense
    };
    mockExpenses[index] = updatedExpense;
    return updatedExpense;
  },

  async deleteExpense(id: number): Promise<void> {
    await delay(500);
    const index = mockExpenses.findIndex(e => e.id === id);
    if (index === -1) throw new Error('Expense not found');
    mockExpenses.splice(index, 1);
  }
};

export const mockCategoriesService = {
  async getCategories(): Promise<string[]> {
    await delay(500);
    return [...mockCategories];
  }
};

// Simulate random errors (uncomment to test error handling)
export const mockExpenseServiceWithErrors = {
  async getExpenses(): Promise<Expense[]> {
    await delay(500);
    if (Math.random() < 0.3) throw new Error('Random error fetching expenses');
    return [...mockExpenses];
  },

  async addExpense(expense: Omit<Expense, 'id'>): Promise<Expense> {
    await delay(500);
    if (Math.random() < 0.3) throw new Error('Random error adding expense');
    const newExpense = {
      ...expense,
      id: Math.max(...mockExpenses.map(e => e.id)) + 1
    };
    mockExpenses.push(newExpense);
    return newExpense;
  },

  async updateExpense(id: number, expense: Partial<Expense>): Promise<Expense> {
    await delay(500);
    if (Math.random() < 0.3) throw new Error('Random error updating expense');
    const index = mockExpenses.findIndex(e => e.id === id);
    if (index === -1) throw new Error('Expense not found');
    
    const updatedExpense = {
      ...mockExpenses[index],
      ...expense
    };
    mockExpenses[index] = updatedExpense;
    return updatedExpense;
  },

  async deleteExpense(id: number): Promise<void> {
    await delay(500);
    if (Math.random() < 0.3) throw new Error('Random error deleting expense');
    const index = mockExpenses.findIndex(e => e.id === id);
    if (index === -1) throw new Error('Expense not found');
    mockExpenses.splice(index, 1);
  }
};