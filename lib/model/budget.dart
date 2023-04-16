import 'dart:math';
import 'expense.dart';

class Budget {
  String id;
  String name;
  double amount;
  DateTime budgetDate;
  List<Expense>? expenses = [];

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.budgetDate,
    this.expenses});

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      budgetDate: json['budgetDate'],
      expenses: json['expenses'] as List<Expense>,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'amount': amount,
    'budgetDate': budgetDate,
    'expenses': (expenses != null) ? expenses: [],
  };
}