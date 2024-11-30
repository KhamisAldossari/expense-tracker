<?php

namespace App\Services;

use App\Core\Logger;

class LoggingService
{
    private $logger;
    
    public function __construct() 
    {
        $this->logger = Logger::getInstance();
    }

    public function logExpenseActivity(string $action, $data, $oldData = null)
    {
        $logData = [
            'user_id' => $data['user_id'] ?? null,            
            'action' => $action,
            'expense_data' => $data,            
            'ip_address' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
            'user_agent' => $this->getUserAgent(),
            'os' => $this->getOperatingSystem($this->getUserAgent()),
            'browser' => $this->getBrowser($this->getUserAgent()),
            'timestamp' => date('Y-m-d H:i:s'),            
        ];

        if ($oldData) {
            $logData['previous_data'] = $oldData;
        }

        $this->logger->info('Expense Activity', $logData);
    }

    private function getUserAgent(): string 
    {
        return $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown';
    }

    private function getOperatingSystem($userAgent): string
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

    private function getBrowser($userAgent): string
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