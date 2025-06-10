import 'package:flutter/material.dart';
import '../../../data/models/detail.suggestion.dart';

class AlertDetailsPage extends StatelessWidget {
  final List<SuggestionDetail> details;

  const AlertDetailsPage({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Sugerencia'),
        centerTitle: true,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: details.length,
        itemBuilder: (context, index) {
          final detail = details[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Información general'),
                  const SizedBox(height: 8),
                  _buildInfoTile('Bandera ', detail.cdCoverage),
                  _buildInfoTile('Orden ', detail.descStPurchase),
                  _buildInfoTile('VEN ', detail.descCurveXyz),
                  const Divider(height: 24),

                  _buildSectionTitle('Producto y Almacén '),
                  const SizedBox(height: 8),
                  _buildInfoTile('Código Almacen ', detail.cdWarehouseGroupLabel),
                  _buildInfoTile('Descripción ', detail.codProd),
                  _buildInfoTile('Unidad de Medida ', detail.desProd),
                  const Divider(height: 24),

                  _buildSectionTitle('Órdenes y Sugerencias '),
                  const SizedBox(height: 8),
                  _buildInfoTile('OC por ingresar ', detail.cdMu),
                  _buildInfoTile('Unidades por Ingresar ', detail.qtPurchaseOrders.toString()),
                  _buildInfoTile('Fecha Límite de Ingreso ', detail.qtPurchaseProduct.toString()),
                  _buildInfoTile('Sugerencia adicional para 2 meses ', detail.dtEndAsc),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: value?.isNotEmpty == true ? value : 'N/A',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.indigo,
      ),
    );
  }
}
