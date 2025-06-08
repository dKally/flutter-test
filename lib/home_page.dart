import 'package:flutter/material.dart';
import 'package:flutter_app/models/finance_record.dart';
import 'package:flutter_app/create_record_page.dart';
import 'package:flutter_app/record_details_page.dart';
import 'package:flutter_app/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<FinanceRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final loadedRecords = await DatabaseService.instance.getRecords();
    setState(() {
      _records.clear();
      _records.addAll(loadedRecords);
    });
  }

  void _navigateToAddRecordPage() async {
    final String? newRecordName = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateRecordPage()),
    );

    if (newRecordName != null && newRecordName.isNotEmpty) {
      final newRecord = FinanceRecord(name: newRecordName);
      final int id = await DatabaseService.instance.insertRecord(newRecord);
      newRecord.id = id;

      setState(() {
        _records.add(newRecord);
      });
    }
  }

  void _navigateToRecordDetails(FinanceRecord record) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordDetailsPage(record: record),
      ),
    );
    await _loadRecords();
  }

  Future<void> _deleteRecord(FinanceRecord recordToDelete) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Registro?'),
        content: Text(
          'Tem certeza que deseja excluir o registro "${recordToDelete.name}"? Todas as transações associadas também serão excluídas.',
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

    if (confirm == true && recordToDelete.id != null) {
      await DatabaseService.instance.deleteRecord(recordToDelete.id!);

      setState(() {
        _records.removeWhere((record) => record.id == recordToDelete.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro "${recordToDelete.name}" excluído!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros Financeiros'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _records.isEmpty
            ? const Text(
                'Nenhum registro ainda. Clique em "+" para adicionar um novo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              )
            : ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final record = _records[index];

                  Color cardColor = record.isClosed
                      ? Colors.grey[300]!
                      : Colors.white;
                  Color textColor = record.isClosed
                      ? Colors.grey[600]!
                      : Colors.black87;
                  FontWeight fontWeight = record.isClosed
                      ? FontWeight.normal
                      : FontWeight.bold;
                  TextDecoration textDecoration = record.isClosed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: cardColor,
                    elevation: record.isClosed ? 1 : 4,
                    child: ListTile(
                      title: Text(
                        record.name,
                        style: TextStyle(
                          fontWeight: fontWeight,
                          color: textColor,
                          decoration: textDecoration,
                        ),
                      ),
                      subtitle: Text(
                        'Total Gasto: R\$ ${record.totalSpent.toStringAsFixed(2)}',
                        style: TextStyle(color: textColor.withOpacity(0.8)),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (record.isClosed)
                            Icon(Icons.lock, color: textColor.withOpacity(0.8)),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            tooltip: 'Excluir Registro',
                            onPressed: () => _deleteRecord(record),
                          ),
                        ],
                      ),
                      onTap: () {
                        _navigateToRecordDetails(record);
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddRecordPage,
        tooltip: 'Adicionar Novo Registro',
        child: const Icon(Icons.add),
      ),
    );
  }
}
