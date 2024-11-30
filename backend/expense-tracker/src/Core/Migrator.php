<?php

namespace App\Core;

use PDO;

class Migrator 
{
   private PDO $db;
   private string $migrationsPath;
   
   public function __construct() 
   {
       // Create database if it doesn't exist
       $this->createDatabase();
       
       // Connect to the database
       $this->db = Database::getInstance();
       $this->migrationsPath = __DIR__ . '/../../database/migrations';
       $this->createMigrationsTable();
   }
   
   private function createDatabase(): void 
   {
       $config = require __DIR__ . '/../config/database.php';
       
       try {
           $pdo = new PDO(
               sprintf(
                   "%s:host=%s;port=%s",
                   $config['driver'],
                   $config['host'],
                   $config['port'] ?? '3306'
               ),
               $config['username'],
               $config['password']
           );
           
           $pdo->exec(sprintf(
               "CREATE DATABASE IF NOT EXISTS %s CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci",
               $config['database']
           ));
           
       } catch (\PDOException $e) {
           throw new \RuntimeException("Could not create database: " . $e->getMessage());
       }
   }
   
   private function createMigrationsTable(): void 
   {
       $this->db->exec("
           CREATE TABLE IF NOT EXISTS migrations (
               id INT AUTO_INCREMENT PRIMARY KEY,
               migration VARCHAR(255),
               batch INT,
               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
           ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
       ");
   }
   
   public function migrate(): void 
   {
       // Get run migrations
       $stmt = $this->db->query("SELECT migration FROM migrations");
       $ranMigrations = $stmt->fetchAll(PDO::FETCH_COLUMN);
       
       // Get all migration files
       $migrationFiles = glob($this->migrationsPath . '/*.php');
       
       if (empty($migrationFiles)) {
           echo "No migrations found.\n";
           return;
       }
       
       // Get current batch number
       $stmt = $this->db->query("SELECT MAX(batch) FROM migrations");
       $batch = (int)$stmt->fetchColumn() + 1;
       
       foreach ($migrationFiles as $file) {
           $filename = basename($file);
           
           if (!in_array($filename, $ranMigrations)) {
               require_once $file;
               
               // Convert filename to class name
               $parts = explode('_', pathinfo($filename, PATHINFO_FILENAME));
               array_shift($parts); // Remove timestamp
               $className = 'Database\\Migrations\\' . str_replace(' ', '', ucwords(implode(' ', $parts)));
               
               $migration = new $className();
               
               echo "Running migration: $filename\n";
               
               try {
                   // Execute migration
                   $migration->up();
                   
                   // Record migration
                   $this->db->exec("
                       INSERT INTO migrations (migration, batch) 
                       VALUES ('$filename', $batch)
                   ");
                   
                   echo "Migration completed: $filename\n";
               } catch (\Exception $e) {
                   echo "Error in migration $filename: " . $e->getMessage() . "\n";
                   throw $e;
               }
           }
       }
   }
   
   public function rollback(): void 
   {
       // Get last batch number
       $stmt = $this->db->query("SELECT MAX(batch) FROM migrations");
       $lastBatch = $stmt->fetchColumn();
       
       if (!$lastBatch) {
           echo "Nothing to rollback.\n";
           return;
       }
       
       // Get migrations from last batch
       $stmt = $this->db->prepare("
           SELECT migration FROM migrations 
           WHERE batch = ? 
           ORDER BY id DESC
       ");
       $stmt->execute([$lastBatch]);
       $migrations = $stmt->fetchAll(PDO::FETCH_COLUMN);
       
       foreach ($migrations as $migration) {
           require_once $this->migrationsPath . '/' . $migration;
           
           // Convert filename to class name
           $parts = explode('_', pathinfo($migration, PATHINFO_FILENAME));
           array_shift($parts); // Remove timestamp
           $className = 'Database\\Migrations\\' . str_replace(' ', '', ucwords(implode(' ', $parts)));
           
           $instance = new $className();
           
           echo "Rolling back: $migration\n";
           
           try {
               // Execute rollback
               $instance->down();
               
               // Remove migration record
               $this->db->exec("
                   DELETE FROM migrations 
                   WHERE migration = '$migration' AND batch = $lastBatch
               ");
               
               echo "Rollback completed: $migration\n";
           } catch (\Exception $e) {
               echo "Error in rollback $migration: " . $e->getMessage() . "\n";
               throw $e;
           }
       }
   }
}