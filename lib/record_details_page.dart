// lib/record_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_app/models/finance_record.dart'; // Ajuste o 'flutter_app' para o nome real do seu projeto se for diferente
import 'package:flutter_app/add_transaction_page.dart'; // Ajuste o 'flutter_app' para o nome real do seu projeto se for diferente
import 'package:flutter_app/services/database_service.dart'; // Ajuste o 'flutter_app' para o nome real do seu projeto se for diferente

class RecordDetailsPage extends StatefulWidget {
  final FinanceRecord record;

  const RecordDetailsPage({super.key, required this.record});

  @override
  State<RecordDetailsPage> createState() => _RecordDetailsPageState();
}

class _RecordDetailsPageState extends State<RecordDetailsPage> {
  // --- FUNÇÃO PARA NAVEGAR PARA A PÁGINA DE ADICIONAR TRANSAÇÃO E PERSISTIR ---
  void _navigateToAddTransactionPage() async {
    // É CRUCIAL garantir que widget.record.id não seja nulo aqui.
    // Isso será garantido na HomePage ao inserir o FinanceRecord.
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
        builder: (context) => AddTransactionPage(
          financeRecordId: widget.record.id!,
        ), // Passa o ID do registro pai
      ),
    );

    if (newTransaction != null) {
      // 1. Adiciona a transação à lista em memória
      setState(() {
        widget.record.transactions.add(newTransaction);
        widget.record.totalSpent += newTransaction.amount;
      });

      // 2. Salva a nova transação no banco de dados
      // O 'id' da transação será preenchido após a inserção.
      await DatabaseService.instance.insertTransaction(newTransaction);

      // 3. Atualiza o FinanceRecord pai no banco de dados (totalSpent)
      await DatabaseService.instance.updateRecord(widget.record);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação adicionada com sucesso!')),
      );
    }
  }
  // --- FIM DA FUNÇÃO ---

  // --- FUNÇÃO PARA FECHAR/REABRIR O REGISTRO E PERSISTIR ---
  void _toggleCloseRecord() async {
    setState(() {
      widget.record.isClosed = !widget.record.isClosed; // Inverte o status
    });

    // 1. Atualiza o FinanceRecord no banco de dados (isClosed)
    await DatabaseService.instance.updateRecord(widget.record);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.record.isClosed ? 'Registro Fechado!' : 'Registro Reaberto!',
        ),
      ),
    );
  }
  // --- FIM DA FUNÇÃO ---

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
                            trailing: Text(
                              'R\$ ${transaction.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
