class UserModel {
  String uid;
  String displayName;
  String currency;

  UserModel({required this.uid, required this.displayName, this.currency = "JOD"});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      displayName: json['displayName'],
      currency: json['currency'] ?? "JOD",
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'displayName': displayName,
    'currency': currency,
  };
}
