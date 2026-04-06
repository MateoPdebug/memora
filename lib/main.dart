import 'package:flutter/material.dart';
import 'pantallas/login.dart';
import 'pantallas/home_Screen.dart';
import 'pantallas/estadistica.dart';
import 'pantallas/crearcuenta.dart';

void main() {
  runApp(const MemoraApp());
}

class MemoraApp extends StatelessWidget {
  const MemoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memora',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',

      // Registro de rutas
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/crearcuenta': (context) => const CrearCuentaScreen()
      },
    );
  }
}
