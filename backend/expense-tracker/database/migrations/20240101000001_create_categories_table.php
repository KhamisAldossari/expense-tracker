<?php

namespace Database\Migrations;

use Database\Migration;

class CreateCategoriesTable extends Migration 
{
    public function up(): void 
    {
        $this->db->exec("
            CREATE TABLE IF NOT EXISTS categories (
                id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        ");
        
        // Insert default categories
        $this->db->exec("
            INSERT INTO categories (name) VALUES 
            ('Food & Dining'),
            ('Transportation'),
            ('Housing'),
            ('Utilities'),
            ('Healthcare'),
            ('Entertainment'),
            ('Shopping'),
            ('Education'),
            ('Travel'),
            ('Others')
        ");
    }
    
    public function down(): void 
    {
        $this->db->exec("DROP TABLE IF EXISTS categories");
    }
}