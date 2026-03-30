import 'package:flutter/material.dart';
import 'estadistica.dart';
class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  String _modo = 'Gastos';

  List<String> get _textos => _modo == 'Gastos'
      ? const [
    '• Usted hizo 12 gastos este mes, principalmente en Alimentación.',
    '• Su gasto más alto fue en Transporte.',
    '• Sus gastos subieron frente al mes anterior.',
  ]
      : const [
    '• Usted registró 4 ingresos este mes, principalmente por Salario.',
    '• Su ingreso más alto fue un pago extra.',
    '• Sus ingresos bajaron frente al mes anterior.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),

      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Estadísticas',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 Selector Gastos / Ingresos
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: _modo,
                dropdownColor: const Color(0xFF1B263B),
                style: const TextStyle(color: Colors.white),
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                      value: 'Gastos', child: Text('Gastos')),
                  DropdownMenuItem(
                      value: 'Ingresos', child: Text('Ingresos')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _modo = v);
                },
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Contenedor del gráfico (demo)
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _modo == 'Gastos'
                          ? Icons.trending_up
                          : Icons.trending_down,
                      size: 50,
                      color: _modo == 'Gastos'
                          ? Colors.redAccent
                          : Colors.greenAccent,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Gráfico de $_modo (demo)',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Resumen en texto
            const Text(
              'Resumen del mes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _textos
                  .map(
                    (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    t,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}