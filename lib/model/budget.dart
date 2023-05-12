import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'expense.dart';

class Budget {
  String id;
  String name;
  double amount;
  Timestamp budgetDate;

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.budgetDate,});

  factory Budget.fromJson(Map<String, dynamic> json) {

    return Budget(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      budgetDate: json['budgetDate'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'amount': amount,
    'budgetDate': budgetDate,
  };
}