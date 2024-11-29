// lib/models/expense.dart
import 'package:flutter/foundation.dart';

class Expense {
  final String? id;
  final double amount;
  final String category;
  final DateTime date;
  final String description;

  Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });
  
  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'],
    amount: json['amount'].toDouble(),
    category: json['category'],
    date: DateTime.parse(json['date']),
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'description': description,
  };

  Expense copyWith({
    String? id,
    double? amount,
    String? description,
    DateTime? date,
    String? category,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Expense &&
    runtimeType == other.runtimeType &&
    id == other.id &&
    amount == other.amount &&
    category == other.category &&
    date == other.date &&
    description == other.description;

  @override
  int get hashCode => Object.hash(id, amount, category, date, description);
}