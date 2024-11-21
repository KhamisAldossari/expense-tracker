<?php

namespace App\Services;

use Illuminate\Support\Facades\Log;

class LoggingService
{
    public function logExpenseActivity(string $action, $data, $oldData = null)
    {
        $logData = [
            'user_id' => auth()->id(),
            'action' => $action,
            'expense_data' => $data,
            'timestamp' => now()
        ];

        if ($oldData) {
            $logData['previous_data'] = $oldData;
        }

        Log::channel('daily')->info('Expense Activity', $logData);
    }
}