<?php

namespace Database\Migrations;

use Database\Migration;

class CreateExpensesTable extends Migration 
{
    public function up(): void 
    {
        $this->db->exec("
            CREATE TABLE IF NOT EXISTS expenses (
                id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                user_id BIGINT UNSIGNED NOT NULL,
                category_id BIGINT UNSIGNED NOT NULL,
                amount DECIMAL(10, 2) NOT NULL,
                description VARCHAR(255) NOT NULL,
                expense_date DATE NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                FOREIGN KEY (category_id) REFERENCES categories(id)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        ");
    }
    
    public function down(): void 
    {
        $this->db->exec("DROP TABLE IF EXISTS expenses");
    }
}