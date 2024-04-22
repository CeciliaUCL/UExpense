class RecordDetails {
  int id;
  String entryType;
  String description;
  double amount;
  String expenseType;
  String date;
  String time;
  String imgPath;

  RecordDetails(this.id, this.entryType, this.description, this.amount,
      this.expenseType, this.date, this.time, this.imgPath);

  factory RecordDetails.fromJson(Map<String, dynamic> json) {
    return RecordDetails(
      json['id'],
      json['entryType'],
      json['description'],
      json['amount'],
      json['expenseType'],
      json['date'],
      json['time'],
      json['imgPath'],
    );
  }
}
