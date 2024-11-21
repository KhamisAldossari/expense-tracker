import { Routes, Route, Navigate } from "react-router-dom";
import Login from "@/components/auth/Login";
import SignUp from "@/components/auth/SignUp";
import Expense from "@/components/expenses/ExpenseTracker";
import AuthGuard from "@/components/guards/AuthGuard";
import GuestGuard from "@/components/guards/GuestGuard";
import DashboardLayout from "@/components/common/DashboardLayout";
const App: React.FC = () => {
  return (
    <Routes>
      {/* Guest routes */}
      <Route element={<GuestGuard />}>
        <Route path="/" element={<Login />} />
        <Route path="/signup" element={<SignUp />} />
      </Route>

      {/* Protected routes with layout */}
      <Route element={<AuthGuard />}>
        <Route
          path="/expenses"
          element={
            <DashboardLayout>
              <Expense />
            </DashboardLayout>
          }
        />
      </Route>

      {/* Catch all route */}
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
};

export default App;