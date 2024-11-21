<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Expense extends Model
{
   use HasFactory;

   protected $fillable = [
       'user_id',
       'category_id',
       'amount',
       'description',
       'expense_date'
   ];

   protected $casts = [
       'expense_date' => 'date'
   ];

   public function user(): BelongsTo
   {
       return $this->belongsTo(User::class);
   }

   public function category(): BelongsTo
   {
       return $this->belongsTo(Category::class);
   }
}