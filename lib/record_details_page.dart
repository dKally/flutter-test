// lib/record_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_app/models/finance_record.dart';
import 'package:flutter_app/add_transaction_page.dart';
import 'package:flutter_app/services/database_service.dart';

class RecordDetailsPage extends StatefulWidget {
  final FinanceRecord record;

  const RecordDetailsPage({super.key, required this.record});

  @override
  State<RecordDetailsPage> createState() => _RecordDetailsPageState();
}

class _RecordDetailsPageState extends State<RecordDetailsPage> {
  void _navigateToAddTransactionPage() async {
    if (widget.record.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro: Registro pai não possui um ID. Salve-o primeiro.',
          ),
        ),
      );
      return;
    }

    final Transaction? newTransaction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddTransactionPage(financeRecordId: widget.record.id!),
      ),
    );

    if (newTransaction != null) {
      setState(() {
        widget.record.transactions.add(newTransaction);
        widget.record.totalSpent += newTransaction.amount;
      });

      await DatabaseService.instance.insertTransaction(newTransaction);
      await DatabaseService.instance.updateRecord(widget.record);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação adicionada com sucesso!')),
      );
    }
  }

  void _toggleCloseRecord() async {
    setState(() {
      widget.record.isClosed = !widget.record.isClosed;
    });

    await DatabaseService.instance.updateRecord(widget.record);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.record.isClosed ? 'Registro Fechado!' : 'Registro Reaberto!',
        ),
      ),
    );
  }

  Future<void> _deleteTransaction(Transaction transactionToDelete) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Transação?'),
        content: Text(
          'Tem certeza que deseja excluir o gasto de R\$ ${transactionToDelete.amount.toStringAsFixed(2)} - "${transactionToDelete.description}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true && transactionToDelete.id != null) {
      await DatabaseService.instance.deleteTransaction(transactionToDelete.id!);

      setState(() {
        widget.record.transactions.removeWhere(
          (t) => t.id == transactionToDelete.id,
        );
        widget.record.totalSpent -= transactionToDelete.amount;
      });

      await DatabaseService.instance.updateRecord(widget.record);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Transação "${transactionToDelete.description}" excluída!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(widget.record.isClosed ? Icons.lock : Icons.lock_open),
            tooltip: widget.record.isClosed
                ? 'Reabrir Registro'
                : 'Fechar Registro',
            onPressed: _toggleCloseRecord,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total Gasto: R\$ ${widget.record.totalSpent.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Transações:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: widget.record.transactions.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma transação ainda. Clique em "+" para adicionar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.record.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = widget.record.transactions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                              transaction.description,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Data: ${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'R\$ ${transaction.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                  tooltip: 'Excluir Transação',
                                  onPressed: () =>
                                      _deleteTransaction(transaction),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTransactionPage,
        tooltip: 'Adicionar Transação',
        child: const Icon(Icons.add),
      ),
    );
  }
}
