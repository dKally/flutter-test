import 'package:flutter/material.dart';
import 'home_page.dart'; // Importa a nossa HomePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'Registros Financeiros', // Título que aparece na barra de tarefas do app
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Define a cor primária do aplicativo
        useMaterial3:
            true, // Habilita o Material Design 3, se quiser um visual mais moderno
      ),
      home:
          const HomePage(), // Define HomePage como a tela inicial do nosso app
    );
  }
}
