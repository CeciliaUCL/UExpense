class AccountRecord {
  String id;
  String type;
  double amount;
  String category;
  DateTime date;
  String description;

  AccountRecord({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type':type,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'description': description,
  };

  static AccountRecord fromJson(Map<String, dynamic> json) => AccountRecord(
    id: json['id'],
    type: json['type'],
    amount: json['amount'],
    category: json['category'],
    date: DateTime.parse(json['date']),
    description: json['description'],
  );
}
