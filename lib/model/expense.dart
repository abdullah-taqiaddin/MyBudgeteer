import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String id;
  String name;
  double amount;
  String budgetId;
  Timestamp expenseDate;
  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.expenseDate,
    required this.budgetId,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      expenseDate: json['expenseDate'],
      budgetId: json['budgetId'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'amount': amount,
        'expenseDate' : expenseDate,
        'budgetId': budgetId,
      };
}