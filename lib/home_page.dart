// lib/home_page.dart

import 'package:flutter/material.dart';
import 'models/finance_record.dart'; // Importa nosso modelo de dados
import 'create_record_page.dart'; // Importa a página de criação

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Agora nossa lista guarda objetos FinanceRecord
  final List<FinanceRecord> _records =
      []; // Usamos '_' para indicar que é uma variável privada

  // Função assíncrona para lidar com a navegação e o retorno de dados
  void _navigateToAddRecordPage() async {
    // Navigator.push() retorna um Future que será completado com o resultado
    // quando a página popped (removida da pilha de navegação).
    final String? newRecordName = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const CreateRecordPage(), // Vai para a CreateRecordPage
      ),
    );

    // Verifica se um nome foi realmente retornado (ou seja, o usuário salvou)
    if (newRecordName != null && newRecordName.isNotEmpty) {
      // Usa setState para reconstruir o widget e exibir o novo registro
      setState(() {
        // Cria uma nova instância de FinanceRecord com o nome retornado
        _records.add(FinanceRecord(name: newRecordName));
      });
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
        // Agora, se a lista estiver vazia, ainda mostramos a mensagem
        // Caso contrário, exibimos a lista de FinanceRecord
        child: _records.isEmpty
            ? const Text(
                'Nenhum registro ainda. Clique em "+" para adicionar um novo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              )
            : ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final record = _records[index]; // Pega o objeto FinanceRecord

                  return Card(
                    // Usamos Card para dar um visual mais agradável
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        record.name, // Exibe o nome do registro
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Total Gasto: R\$ ${record.totalSpent.toStringAsFixed(2)}', // Mostra o total gasto
                      ),
                      // trailing: Icon(record.isClosed ? Icons.lock : Icons.lock_open), // Exemplo de ícone
                      onTap: () {
                        // TODO: Implementar navegação para a página de detalhes do registro
                        print('Clicou no registro: ${record.name}');
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddRecordPage, // Chama nossa função de navegação
        tooltip: 'Adicionar Novo Registro',
        child: const Icon(Icons.add),
      ),
    );
  }
}
