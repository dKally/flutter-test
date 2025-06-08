class FinanceRecord {
  int? id;
  String name;
  double totalSpent;
  bool isClosed;
  List<Transaction> transactions;

  FinanceRecord({
    this.id,
    required this.name,
    this.totalSpent = 0.0,
    this.isClosed = false,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'totalSpent': totalSpent,
      'isClosed': isClosed ? 1 : 0,
    };
  }

  factory FinanceRecord.fromMap(Map<String, dynamic> map) {
    return FinanceRecord(
      id: map['id'] as int,
      name: map['name'] as String,
      totalSpent: map['totalSpent'] as double,
      isClosed: (map['isClosed'] as int) == 1,
      transactions: [],
    );
  }
}

class Transaction {
  int? id;
  int financeRecordId;
  double amount;
  String description;
  DateTime date;

  Transaction({
    this.id,
    required this.financeRecordId,
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'financeRecordId': financeRecordId,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int,
      financeRecordId: map['financeRecordId'] as int,
      amount: map['amount'] as double,
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }
}
