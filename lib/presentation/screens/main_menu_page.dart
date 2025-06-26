// lib/screens/main_menu_page.dart
import 'package:flutter/material.dart';
import '../../data/models/application.dart';
import 'alert_page.dart';
import 'central_warehouse_coverage_page.dart';
import 'pending_order_page.dart';
import 'purchase_orders_condition_page.dart';
import 'skus_coverage_IPRESS_page.dart';

class MainMenuPage extends StatelessWidget {
  final String userName;
  final List<Application> applications;

  const MainMenuPage({super.key, required this.userName, required this.applications});

bool hasAccess(String appName) {
  return applications.any((app) => app.nameApp  == appName);
}

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
              if (hasAccess('navWarehouseCoverage'))
                _buildOption(context, 'Cobertura en el Almacén Central', Icons.dashboard, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CentralWarehouseCoveragePage()));
                }),
              if (hasAccess('navPurcharseCondition'))
                _buildOption(context, 'Condición de Compra', Icons.analytics, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PurchaseOrdersConditionPage()));
                }),
              if (hasAccess('navAlert'))
                _buildOption(context, 'Alerta Sugerencia Compra', Icons.dashboard, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AlertPage()));
                }),
              if (hasAccess('navIPRESSCoverage'))
                _buildOption(context, 'Cobertura en la IPRESS', Icons.shopping_cart, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SKUsCoverageIPRESSPage()));
                }),
              if (hasAccess('navOCPendienteIngreso'))
                _buildOption(context, 'OC Pendiente de Ingreso', Icons.people, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PendingOrderPage()));
                }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOption(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.indigo.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
      ),
    );
  }
}
