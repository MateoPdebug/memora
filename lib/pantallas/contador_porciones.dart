import 'package:flutter/material.dart';
void main() => runApp(const AppContador());
class AppContador extends StatelessWidget {
  const AppContador({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador de Porciones',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ContadorPorciones(), // ← pantalla inicial
    );
  }
}

class ContadorPorciones extends StatefulWidget {
  const ContadorPorciones({super.key});
  @override
  State<ContadorPorciones> createState() {
    // Crea y devuelve el objeto State
    return _ContadorPorcionesState();
  }
}
class _ContadorPorcionesState extends State<ContadorPorciones> {
  // ★ VARIABLE DE STATE — vive fuera de build()
  int _cantidad = 1;
  // ── ACCIONES (eventos de los botones) ──────────────
  void _sumar() {
    setState(() {
      _cantidad++; // sube 1
    });
  }
  void _restar() {
    setState(() {
      if (_cantidad > 1) _cantidad--; // no bajar de 1
    });
  }
  // ── PANTALLA ────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contador de Porciones'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Text('¿Cuántas porciones?',
              style: TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          // ★ Muestra _cantidad — se actualiza con setState()
          Text('$_cantidad',
              style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            // ★ Botón − conectado a _restar()
            ElevatedButton(
            onPressed: _restar, // ← callback
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(64, 64)),
            child: const Text('−',
                style: TextStyle(fontSize: 28)),
          ),
              const SizedBox(width: 40),
              // ★ Botón + conectado a _sumar()
              ElevatedButton(
                onPressed: _sumar, // ← callback
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(64, 64)),
                child: const Text('+',
                    style: TextStyle(fontSize: 28)),
              ),
            ],
          ),
              ],
          ),
        ),
    );
  }
}