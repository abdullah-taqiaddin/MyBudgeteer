import 'budget.dart';

class UserModel{

  String uid;
  String displayName;
  String? currency = "JOD";
  List<Budget>? budgets = [];

  UserModel({
    required this.uid,
    required this.displayName,
    this.currency = "JOD",
    this.budgets
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return UserModel(
      uid: json!['uid'],
      displayName: json!['displayName'],
      currency: json!['currency'],
      budgets: (json!['budgets'] != null) ? json!['budgets'] as List<Budget> : [],
    );
  }


  Map<String, dynamic> toJson() => {
    'uid': uid,
    'displayName': displayName,
    'currency': currency,
    'budgets': (budgets != null) ? budgets : [],
  };
}