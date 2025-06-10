import 'package:flutter/material.dart';
import '../../../data/models/supplying.warehouse.dart';

class IPRESSReportPage extends StatefulWidget {
  final List<SupplyingWarehouse> reports;

  const IPRESSReportPage({super.key, required this.reports});

  @override
  State<IPRESSReportPage> createState() => _IPRESSReportPageState();
}

class _IPRESSReportPageState extends State<IPRESSReportPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filtrado por codItemPk
    final filteredReports = widget.reports.where((s) =>
      s.codItemPk.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de SKUs Según IPRESS'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar por Código de Producto',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredReports.isEmpty
                ? const Center(child: Text('No se encontraron coincidencias'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Información general del reporte'),
                              const SizedBox(height: 8),
                              _buildInfoTile('Cod. Almacén', report.cdWarehouseGroupLabel),
                              _buildInfoTile('Almacén', report.dsWarehouse),
                              _buildInfoTile('Cod. Producto', report.codItemPk),
                              _buildInfoTile('Descripción', report.dsProduct),
                              _buildInfoTile('UM', report.cdMu),
                              _buildInfoTile('Bandera', report.cdCoverage),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
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