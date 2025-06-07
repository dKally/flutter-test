// lib/models/finance_record.dart

class FinanceRecord {
  String name; // O nome da lista (ex: "Compras do Mês", "Viagem de Férias")
  double totalSpent; // O total gasto nessa lista
  bool isClosed; // Indica se a lista está "fechada" (finalizada)
  List<Transaction>
  transactions; // A lista de transações (gastos) dentro deste registro

  // Construtor da classe FinanceRecord
  FinanceRecord({
    required this.name, // O nome é obrigatório
    this.totalSpent = 0.0, // Começa com 0.0 por padrão
    this.isClosed = false, // Começa como false (aberta) por padrão
    List<Transaction>?
    transactions, // A lista de transações pode ser nula inicialmente
  }) : transactions =
           transactions ??
           []; // Se transactions for nulo, inicializa como uma lista vazia
}

class Transaction {
  double amount; // O valor da transação (ex: 20.0)
  String description; // A descrição do que foi gasto (ex: "Lanche", "Gasolina")
  DateTime date; // A data em que a transação ocorreu

  // Construtor da classe Transaction
  Transaction({
    required this.amount, // O valor é obrigatório
    required this.description, // A descrição é obrigatória
    required this.date, // A data é obrigatória
  });
}
