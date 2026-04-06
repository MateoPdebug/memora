import 'package:flutter/material.dart';

class EstadisticasScreen extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> gastosPorCategoria;
  
  const EstadisticasScreen({
    super.key,
    required this.gastosPorCategoria,
  });

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  String _modo = 'Gastos';

  
  int get totalGastos => _todosLosGastos.length;
  double get gastoTotal => _todosLosGastos.fold(0.0, (sum, g) => sum + (g['monto'] ?? 0));
  String get categoriaPrincipal => _categoriaConMasGasto();
  Map<String, double> get gastosPorCategoria => _calcularGastosPorCategoria();

  List<Map<String, dynamic>> get _todosLosGastos {
    final todos = <Map<String, dynamic>>[];
    widget.gastosPorCategoria.forEach((cat, gastos) {
      todos.addAll(gastos);
    });
    return todos;
  }

  String _categoriaConMasGasto() {
    if (_todosLosGastos.isEmpty) return 'Ninguna';
    final maxGasto = _todosLosGastos.reduce((a, b) => (a['monto'] ?? 0) > (b['monto'] ?? 0) ? a : b);
    return maxGasto['categoria'] ?? 'Desconocida';
  }

  Map<String, double> _calcularGastosPorCategoria() {
    final mapa = <String, double>{};
    widget.gastosPorCategoria.forEach((cat, gastos) {
      mapa[cat] = gastos.fold(0.0, (sum, g) => sum + (g['monto'] ?? 0));
    });
    return mapa;
  }

  List<String> get _textos => _modo == 'Gastos'
    ? [
        '• Total de $totalGastos gastos este mes, principalmente en $categoriaPrincipal.',
        '• Gasto total: \$${gastoTotal.toStringAsFixed(2)}',
        '• Categoría más gastada: $categoriaPrincipal',
        if (totalGastos > 0) 
          '• Gasto promedio: \$${(_todosLosGastos.isNotEmpty ? (gastoTotal / totalGastos) : 0).toStringAsFixed(2)}',
      ]
    : const [
        '• No hay datos de ingresos aún.',
        '• Agrega ingresos en la próxima actualización.',
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
                  DropdownMenuItem(value: 'Gastos', child: Text('Gastos')),
                  DropdownMenuItem(value: 'Ingresos', child: Text('Ingresos')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _modo = v);
                },
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 GRÁFICO REAL con tus datos
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Resumen $_modo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Expanded(
                      child: gastosPorCategoria.isEmpty
                          ? const Center(
                              child: Text(
                                'Sin datos aún',
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          : ListView.builder(
                              itemCount: gastosPorCategoria.length,
                              itemBuilder: (context, index) {
                                final entry = gastosPorCategoria.entries.elementAt(index);
                                final porcentaje = gastoTotal > 0 ? (entry.value / gastoTotal * 100) : 0;
                                
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      // Avatar de categoría
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.8),
                                        child: Text(
                                          entry.key[0].toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Nombre y monto
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              entry.key,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              '\$${entry.value.toStringAsFixed(2)} (${porcentaje.toStringAsFixed(1)}%)',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Barra de progreso
                                      Container(
                                        width: 80,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: FractionallySizedBox(
                                          widthFactor: (porcentaje / 100).clamp(0.0, 1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Colors.deepPurpleAccent, Colors.purple],
                                              ),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 🔹 Resumen en texto REAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Resumen del mes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    totalGastos > 0 ? '$totalGastos gastos' : 'Sin datos',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 
            ..._textos.map(
              (texto) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        texto,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
