// lib/create_record_page.dart

import 'package:flutter/material.dart';

class CreateRecordPage extends StatefulWidget {
  const CreateRecordPage({super.key});

  @override
  State<CreateRecordPage> createState() => _CreateRecordPageState();
}

class _CreateRecordPageState extends State<CreateRecordPage> {
  // Controlador de texto para o TextField. Ele nos permite acessar o valor digitado.
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    // É importante liberar o controlador quando o widget não for mais necessário
    // para evitar vazamentos de memória.
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Registro Financeiro'), // Título da AppBar
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ), // Adiciona um espaçamento interno de 16 pixels
        child: Column(
          // Column organiza os widgets verticalmente
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Estica os filhos horizontalmente
          children: [
            TextField(
              controller:
                  _nameController, // Vincula o TextField ao nosso controlador
              decoration: const InputDecoration(
                labelText:
                    'Nome do Registro', // Rótulo que aparece acima do campo
                hintText:
                    'Ex: Compras de Julho, Lanches da Semana', // Texto de sugestão
                border: OutlineInputBorder(), // Borda ao redor do campo
              ),
            ),
            const SizedBox(
              height: 20,
            ), // Espaçamento vertical entre o campo e o botão
            ElevatedButton(
              onPressed: () {
                // Ao pressionar o botão "Salvar"
                final String recordName =
                    _nameController.text; // Pega o texto digitado
                if (recordName.isNotEmpty) {
                  // Se o nome não estiver vazio
                  // Navigator.pop() remove a tela atual da pilha de navegação
                  // e retorna o valor (recordName) para a tela anterior (HomePage).
                  Navigator.pop(context, recordName);
                } else {
                  // Opcional: mostrar um aviso se o nome estiver vazio
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Por favor, insira um nome para o registro.',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ), // Preenchimento interno do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // Bordas arredondadas do botão
                ),
              ),
              child: const Text(
                'Salvar Registro',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
