import 'package:flutter/material.dart';
import 'package:flutter_app/home_page.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

// Importação condicional para sqflite_common_ffi
// Este import SÓ será usado se a plataforma for desktop (Linux, Windows, macOS)
// ou se for um ambiente de teste que usa o sqflite_common_ffi.
// Em Android/iOS, este import é ignorado durante o build.
import 'package:sqflite_common_ffi/sqflite_ffi.dart' //
    if (dart.library.js_util) 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // apenas web aqui

void main() {
  // --- INICIALIZAÇÃO CONDICIONAL DO SQFLITE  ---
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    // Apenas inicializa o FFI se a plataforma for desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // --- FIM DA INICIALIZAÇÃO CONDICIONAL ---

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financeiro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
