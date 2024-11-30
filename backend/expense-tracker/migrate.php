<?php

require_once 'vendor/autoload.php';

// Load environment variables
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

$migrator = new App\Core\Migrator();

// Check command line argument
$command = $argv[1] ?? 'migrate';

try {
    switch ($command) {
        case 'migrate':
            $migrator->migrate();
            break;
        case 'rollback':
            $migrator->rollback();
            break;
        default:
            echo "Unknown command. Use 'migrate' or 'rollback'\n";
    }
} catch (\Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}