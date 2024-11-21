export interface Category {
  id: number;
  name: string;
}

export interface Expense {
  id: number;
  amount: number;
  description: string;
  expense_date: string;
  category: Category;
  created_at: string;
}

export interface ExpenseResponse {
  data: Expense[];
}

export interface ExpenseCreateUpdatePayload {
  category_id: number;
  amount: number;
  description: string;
  expense_date: string;
}

