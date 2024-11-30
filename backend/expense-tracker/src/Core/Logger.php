<?php

namespace App\Core;

use Monolog\Logger as MonologLogger;
use Monolog\Handler\StreamHandler;
use Monolog\Handler\RotatingFileHandler;

class Logger 
{
    private static ?MonologLogger $instance = null;
    
    public static function getInstance(): MonologLogger 
    {
        if (self::$instance === null) {
            self::$instance = new MonologLogger('expense_tracker');
            
            // Daily rotating log file
            $logPath = __DIR__ . '/../../logs/expense_tracker.log';
            self::$instance->pushHandler(new RotatingFileHandler($logPath, 14));
        }
        
        return self::$instance;
    }
}