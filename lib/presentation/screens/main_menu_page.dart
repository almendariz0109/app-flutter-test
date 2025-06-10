// lib/screens/main_menu_page.dart
import 'package:flutter/material.dart';
import 'central_warehouse_coverage_page.dart';
import 'pending_order_page.dart';
import 'skus_coverage_IPRESS_page.dart';

class MainMenuPage extends StatelessWidget {
  final String userName;

  const MainMenuPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cabecera
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          color: Colors.indigo,
          child: Text(
            'Bienvenido $userName',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Opciones
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildOption(context, 'Cobertura en el Almacen Central', Icons.dashboard, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CentralWarehouseCoveragePage()),
                );
              }),
              const SizedBox(height: 16),
              _buildOption(context, 'Condición de Compra', Icons.analytics, () {}),
              const SizedBox(height: 16),
              _buildOption(context, 'Cobertura en la IPRESS', Icons.shopping_cart, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SKUsCoverageIPRESSPage()),
                );
              }),
              const SizedBox(height: 16),
              _buildOption(context, 'OC Pendiente de Ingreso', Icons.people, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PendingOrderPage()),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOption(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
    );
  }
}
