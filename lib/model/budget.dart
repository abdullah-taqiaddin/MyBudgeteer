import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'expense.dart';

class Budget {
  String id;
  String name;
  double amount;
  Timestamp budgetDate;
  double? totalSpent = 0.0;

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.budgetDate, this.totalSpent,});

  factory Budget.fromJson(Map<String, dynamic> json) {

    return Budget(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      budgetDate: json['budgetDate'],
      totalSpent: json['totalSpent'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'amount': amount,
    'budgetDate': budgetDate,
    'totalSpent': totalSpent,
  };
}