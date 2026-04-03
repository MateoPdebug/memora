import 'dart:ui';
import 'package:memora/models/categorias.dart';
import '../widgets/categoria_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<Map<String, dynamic>>> gastosPorCategoria = {};
  List<Categoria> categorias = [
    Categoria(nombre: "Comida", icono: Icons.fastfood),
    Categoria(nombre: "Transporte", icono: Icons.directions_bus),
    Categoria(nombre: "Compras", icono: Icons.shopping_cart),
    Categoria(nombre: "Salud", icono: Icons.local_hospital),
    Categoria(nombre: "Entretenimiento", icono: Icons.sports_esports),
  ];
  void abrirCategoria(Categoria categoria) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D1B2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return CategoriaModal(
          categoria: categoria,
          gastos: gastosPorCategoria[categoria.nombre] ?? [],
          onAgregar: (nuevoGasto) {
            setState(() {
              gastosPorCategoria.putIfAbsent(categoria.nombre, () => []);
              gastosPorCategoria[categoria.nombre]!.add(nuevoGasto);
            });
          },
          onEditar: (gastoActual, gastoEditado) {
            setState(() {
              final gastos = gastosPorCategoria[categoria.nombre]!;
              final index = gastos.indexWhere(
                (g) =>
                    g['descripcion'] == gastoActual['descripcion'] &&
                    g['monto'] == gastoActual['monto'],
              );
              if (index != -1) {
                gastos[index] = gastoEditado;
              }
            });
          },
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: const Text(
          'Memora',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF0D1B2A),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurpleAccent),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'configuracion',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/images/memorabackground.png',
                width: 300,
                height: 300,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 0),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/estadisticas');
                    },
                    icon: const Icon(Icons.bar_chart),
                    label: const Text(
                      'Ver Estadísticas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7F5AF0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: categorias.length,
                    itemBuilder: (context, index) {
                      final categoria = categorias[index];
                      final gastos = gastosPorCategoria[categoria.nombre] ?? [];

                      if (gastos.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Card(
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor: const Color(0xFF1B263B),
                          backgroundColor: const Color(0xFF1B263B),
                          iconColor: Colors.white70,
                          collapsedIconColor: Colors.white70,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                categoria.nombre,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "\$${gastos.fold(0.0, (sum, g) => sum + (g['monto'] ?? 0)).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7F5AF0),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            
                            SizedBox(
                              height: gastos.length > 3
                                  ? 200
                                  : null, // Altura fija si hay muchos
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: gastos.length > 3
                                    ? const AlwaysScrollableScrollPhysics()
                                    : const NeverScrollableScrollPhysics(),
                                itemCount: gastos.length,
                                itemBuilder: (context, gastoIndex) {
                                  final gasto = gastos[gastoIndex];
                                  return ListTile(
                                    dense: true,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.deepPurpleAccent
                                          .withOpacity(0.3),
                                      child: Text(
                                        categoria.nombre[0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      gasto['descripcion'] ?? 'Sin descripción',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Text(
                                      "\$${(gasto['monto'] ?? 0).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF7F5AF0),
                                      ),
                                    ),
                                  );
                                },
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
        ],
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: const Color(0xFF7F5AF0),
        icon: Icons.add,
        activeIcon: Icons.close,
        iconTheme: const IconThemeData(color: Colors.white),
        overlayColor: Colors.black,
        overlayOpacity: 0.0,

        children: [
          ...categorias.map((cat) {
            return SpeedDialChild(
              backgroundColor: const Color(0xFF7F5AF0),
              child: Icon(cat.icono, color: Colors.white),
              label: cat.nombre,
              labelStyle: const TextStyle(color: Colors.black),

              onTap: () {
                abrirCategoria(cat);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
