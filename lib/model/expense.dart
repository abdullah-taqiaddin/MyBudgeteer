class Expense {
  String id;
  String name;
  double amount;
  String budgetReference;

  Expense({ required this.id,required this.name,required this.amount,required this.budgetReference});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      name: json['name'],
      amount: json['amount'].toDouble(),
      budgetReference: json['budgetReference'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'amount': amount,
    'budgetReference': budgetReference,
  };
}
