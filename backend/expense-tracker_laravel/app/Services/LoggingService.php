<?php

namespace App\Services;

use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Request;

class LoggingService
{
    public function logExpenseActivity(string $action, $data, $oldData = null)
    {
        $logData = [
            'user_id' => auth()->id(),            
            'action' => $action,
            'expense_data' => $data,            
            'ip_address' => Request::ip(),
            'user_agent' => Request::userAgent(),
            'os' => $this->getOperatingSystem(Request::userAgent()),
            'browser' => $this->getBrowser(Request::userAgent()),
            'timestamp' => now(),            
        ];

        if ($oldData) {
            $logData['previous_data'] = $oldData;
        }

        Log::channel('daily')->info('Expense Activity', $logData);
    }

    private function getOperatingSystem($userAgent)
    {
        $os_array = [
            '/windows/i'    =>  'Windows',
            '/linux/i'      =>  'Linux',
            '/ubuntu/i'     =>  'Ubuntu',
            '/iphone/i'     =>  'iPhone',
            '/ipad/i'       =>  'iPad',
            '/android/i'    =>  'Android',
            '/macintosh|mac os x/i' => 'macOS'
        ];

        foreach ($os_array as $regex => $value) {
            if (preg_match($regex, $userAgent)) {
                return $value;
            }
        }

        return 'Unknown OS';
    }

    private function getBrowser($userAgent)
    {
        $browser_array = [
            '/msie/i'       =>  'Internet Explorer',
            '/firefox/i'    =>  'Firefox',
            '/safari/i'     =>  'Safari',
            '/chrome/i'     =>  'Chrome',
            '/edge/i'       =>  'Edge',
            '/opera/i'      =>  'Opera',
            '/mobile/i'     =>  'Mobile Browser'
        ];

        foreach ($browser_array as $regex => $value) {
            if (preg_match($regex, $userAgent)) {
                return $value;
            }
        }

        return 'Unknown Browser';
    }
}