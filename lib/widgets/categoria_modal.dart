import 'package:flutter/material.dart';
import '/models/categorias.dart';

class CategoriaModal extends StatefulWidget {
  final Categoria categoria;
  final List<Map<String, dynamic>> gastos;
  final Function(Map<String, dynamic>) onAgregar;
  final Function(Map<String, dynamic>, Map<String, dynamic>) onEditar; 

  const CategoriaModal({
    super.key,
    required this.categoria,
    required this.gastos,
    required this.onAgregar,
    required this.onEditar, 
  });

  @override
  State<CategoriaModal> createState() => _CategoriaModalState();
}

class _CategoriaModalState extends State<CategoriaModal> {

  void agregarGasto(String descripcion, double monto) {
    final nuevo = {
      "descripcion": descripcion,
      "monto": monto,
      "categoria": widget.categoria.nombre,
    };
    widget.onAgregar(nuevo);
    setState(() {});
  }

  void editarGasto(Map<String, dynamic> gastoActual, String nuevaDescripcion, double nuevoMonto) {
    final editado = {
      "descripcion": nuevaDescripcion,
      "monto": nuevoMonto,
      "categoria": widget.categoria.nombre,
    };
    widget.onEditar(gastoActual, editado);
    setState(() {});
  }

  void mostrarDialogo([Map<String, dynamic>? gastoParaEditar]) {
    String descripcion = gastoParaEditar?['descripcion'] ?? "";
    String montoTexto = gastoParaEditar?['monto']?.toString() ?? "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            gastoParaEditar == null 
              ? "Nuevo gasto (${widget.categoria.nombre})"
              : "Editar gasto"
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: descripcion),
                onChanged: (value) => descripcion = value,
                decoration: const InputDecoration(hintText: "Descripción"),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: montoTexto),
                onChanged: (value) => montoTexto = value,
                decoration: const InputDecoration(hintText: "Monto"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final monto = double.tryParse(montoTexto);
                if (monto != null && descripcion.trim().isNotEmpty) {
                  if (gastoParaEditar == null) {
                    agregarGasto(descripcion, monto);
                  } else {
                    editarGasto(gastoParaEditar, descripcion, monto);
                  }
                }
                Navigator.pop(context);
              },
              child: Text(gastoParaEditar == null ? "Guardar" : "Actualizar"),
            ),
          ],
        );
      },
    );
  }

  double get total {
    return widget.gastos.fold(0.0, (sum, item) => sum + (item["monto"] ?? 0));
  }

 @override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      left: 16,
      right: 16,
      top: 20,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                widget.categoria.nombre,
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Total: \$${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white70, 
                  fontSize: 18
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),

        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: widget.gastos.length,
            itemBuilder: (context, index) {
              final gasto = widget.gastos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.white.withOpacity(0.1),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    gasto["descripcion"] ?? 'Sin descripción',
                    style: const TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.w600,
                      fontSize: 16
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "${gasto["categoria"]}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 250, 250, 249).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "\$${gasto["monto"].toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255), 
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color.fromARGB(255, 245, 244, 243), size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => mostrarDialogo(gasto),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => mostrarDialogo(),
            icon: const Icon(Icons.add, size: 20),
            label: const Text("Agregar gasto", style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}
}
