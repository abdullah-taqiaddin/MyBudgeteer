import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'expense.dart';

class Budget {
  String id;
  String name;
  double amount;
  Timestamp budgetDate;
  List<Expense>? expenses = [];

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.budgetDate,
    this.expenses});

  factory Budget.fromJson(Map<String, dynamic> json) {
    var expensesJson = json['expenses'] as List<dynamic>;
    var expenses = expensesJson.map((e) => Expense.fromJson(e)).toList();

    return Budget(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      budgetDate: json['budgetDate'],
      expenses: expenses,
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