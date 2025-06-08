// lib/models/finance_record.dart

class FinanceRecord {
  int? id; // O ID do banco de dados, será gerado automaticamente
  String name;
  double totalSpent;
  bool isClosed;
  List<Transaction> transactions; // A lista de transações dentro deste registro

  FinanceRecord({
    this.id, // O ID é opcional ao criar um novo FinanceRecord no código
    required this.name,
    this.totalSpent = 0.0,
    this.isClosed = false,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? [];

  // --- Método para converter um FinanceRecord para um Map (para salvar no DB) ---
  Map<String, dynamic> toMap() {
    return {
      'id': id, // O ID pode ser nulo para novos registros
      'name': name,
      'totalSpent': totalSpent,
      'isClosed': isClosed
          ? 1
          : 0, // SQLite não tem booleanos, 1 para true, 0 para false
      // As transações serão salvas em uma tabela separada,
      // então não as incluímos diretamente aqui.
    };
  }

  // --- Construtor para criar um FinanceRecord a partir de um Map (do DB) ---
  factory FinanceRecord.fromMap(Map<String, dynamic> map) {
    return FinanceRecord(
      id: map['id'] as int,
      name: map['name'] as String,
      totalSpent: map['totalSpent'] as double,
      isClosed:
          (map['isClosed'] as int) == 1, // Converte 1/0 de volta para boolean
      // As transações serão carregadas separadamente
      transactions:
          [], // Inicialmente vazia, será preenchida pelo serviço de DB
    );
  }
}

class Transaction {
  int? id; // ID da transação
  int
  financeRecordId; // FOREIGN KEY: ID do FinanceRecord ao qual esta transação pertence
  double amount;
  String description;
  DateTime date;

  Transaction({
    this.id,
    required this.financeRecordId, // Obrigatório agora
    required this.amount,
    required this.description,
    required this.date,
  });

  // --- Método para converter uma Transaction para um Map (para salvar no DB) ---
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'financeRecordId': financeRecordId,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(), // Salva a data como string ISO 8601
    };
  }

  // --- Construtor para criar uma Transaction a partir de um Map (do DB) ---
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int,
      financeRecordId: map['financeRecordId'] as int,
      amount: map['amount'] as double,
      description: map['description'] as String,
      date: DateTime.parse(
        map['date'] as String,
      ), // Converte a string de volta para DateTime
    );
  }
}
