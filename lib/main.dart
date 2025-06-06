import 'package:flutter/material.dart';

// =============== COMPONENTES/Widgets ===============
class Header extends StatelessWidget {
  final String title;

  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(text));
  }
}

// =============== PÁGINA PRINCIPAL ===============
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meu App')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Header(title: 'Bem-vindo!'), // Componente Header
            SizedBox(height: 20),
            Text('Este é um exemplo de organização'),
            SizedBox(height: 40),
            CustomButton(
              // Componente Botão
              text: 'Clique aqui',
              onPressed: () => print('Botão clicado!'),
            ),
          ],
        ),
      ),
    );
  }
}

// =============== APP PRINCIPAL ===============
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // Página inicial
    );
  }
}

void main() => runApp(MyApp());
