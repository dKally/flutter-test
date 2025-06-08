// lib/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_app/models/finance_record.dart';
import 'package:flutter_app/create_record_page.dart';
import 'package:flutter_app/record_details_page.dart';
// Unused import: 'package:flutter_app/record_details_page.dart'.
// Try removing the import directive.dartunused_import
import 'package:flutter_app/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Agora a lista será carregada do banco de dados
  final List<FinanceRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords(); // Carrega os registros do DB quando a página é inicializada
  }

  // --- NOVA FUNÇÃO: CARREGAR REGISTROS DO BANCO DE DADOS ---
  Future<void> _loadRecords() async {
    final loadedRecords = await DatabaseService.instance.getRecords();
    setState(() {
      _records.clear(); // Limpa a lista atual (se houver)
      _records.addAll(loadedRecords); // Adiciona os registros carregados do DB
    });
  }
  // --- FIM DA NOVA FUNÇÃO ---

  // --- MODIFICADO: SALVAR NOVO REGISTRO NO BANCO DE DADOS ---
  void _navigateToAddRecordPage() async {
    final String? newRecordName = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateRecordPage()),
    );

    if (newRecordName != null && newRecordName.isNotEmpty) {
      // Cria o FinanceRecord (sem ID ainda)
      final newRecord = FinanceRecord(name: newRecordName);
      // Insere no banco de dados e espera pelo ID gerado
      final int id = await DatabaseService.instance.insertRecord(newRecord);
      // Atribui o ID gerado pelo DB ao objeto em memória
      newRecord.id = id;

      setState(() {
        _records.add(newRecord);
      });
    }
  }
  // --- FIM DA MODIFICAÇÃO ---

  void _navigateToRecordDetails(FinanceRecord record) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordDetailsPage(record: record),
        //         The method 'RecordDetailsPage' isn't defined for the type '_HomePageState'.
        // Try correcting the name to the name of an existing method, or defining a method named 'RecordDetailsPage'.dartundefined_method
      ),
    );

    // Após retornar da RecordDetailsPage, recarregar a lista para garantir que
    // qualquer mudança (totalSpent, isClosed) seja refletida.
    await _loadRecords();
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
                      trailing: record.isClosed
                          ? Icon(Icons.lock, color: textColor.withOpacity(0.8))
                          : null,
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
