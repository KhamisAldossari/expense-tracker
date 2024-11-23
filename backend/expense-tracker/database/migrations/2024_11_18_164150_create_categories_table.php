<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('categories', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->timestamps();
        });
    
        // Default categories
        $categories = [
            ['name' => 'Food'],
            ['name' => 'Transportation'],
            ['name' => 'Entertainment'],
            ['name' => 'Shopping'],
            ['name' => 'Bills'],
            ['name' => 'Healthcare'],
            ['name' => 'Other']
        ];
    
        DB::table('categories')->insert($categories);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('categories');
    }
};
