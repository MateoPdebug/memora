import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
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
              fontWeight: FontWeight.bold, // más gruesa
              letterSpacing: 1.2, // un poquito más elegante
              color: Colors.white,
            ),
          )

      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF0D1B2A),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const[
            DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent
                ),
                child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    )
                )
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                  'configuracion',
              style: TextStyle(
              color: Colors.white,
              fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [

          /// 🔹 Fondo con icono transparente
          Center(
            child: Opacity(
              opacity: 0.08, // más sutil
              child: Icon(
                Icons.account_balance_wallet,
                size: 250,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),

          /// 🔹 Contenido encima
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                const SizedBox(height: 40),

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

          SpeedDialChild(
            backgroundColor: const Color(0xFF7F5AF0),
            child: const Icon(Icons.fastfood, color: Colors.white),
            label: 'Comida',
            labelStyle: const TextStyle(color: Colors.black),
          ),

          SpeedDialChild(
            backgroundColor: const Color(0xFF7F5AF0),
            child: const Icon(Icons.directions_bus_rounded, color: Colors.white),
            label: 'Transporte',
            labelStyle: const TextStyle(color: Colors.black),
          ),

          SpeedDialChild(
            backgroundColor: const Color(0xFF7F5AF0),
            child: const Icon(Icons.shopping_cart, color: Colors.white),
            label: 'Compras',
            labelStyle: const TextStyle(color: Colors.black),
          ),

        ],
      ),
    );
  }
}