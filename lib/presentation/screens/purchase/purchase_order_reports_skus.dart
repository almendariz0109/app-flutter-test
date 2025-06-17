import 'package:flutter/material.dart';
import '../../../core/services/purchase_ordes_condition_service.dart';
import '../../../data/models/detail.suggestion.dart';

class PurchaseOrderSKUsReportPage extends StatefulWidget {
  final List<SuggestionDetail> reports;
  final String stPurcharse;
  final String cdWarehouseGroupLabel;
  final String? idGroup;
  final String? idFlag;
  final String? curve;


  const PurchaseOrderSKUsReportPage({
      super.key, 
      required this.reports,
      required this.cdWarehouseGroupLabel,
      required this.stPurcharse,
      this.idGroup,
      this.idFlag,
      this.curve,
    });

  @override
  State<PurchaseOrderSKUsReportPage> createState() => _PurchaseOrderSKUsState();
}

class _PurchaseOrderSKUsState extends State<PurchaseOrderSKUsReportPage> {
  final _purchaseOrderConditionService = PurchaseOrdersConditionService();
  
  String _searchQuery = '';
  String? _selectedCurve = '';
  bool isLoading = true;

  List<SuggestionDetail> _reportsFilteredByCurve = [];


    @override
  void initState() {
    super.initState();
    _selectedCurve = widget.curve ?? '';
    _reportsFilteredByCurve = widget.reports;

  }


  Future<void> fetchData({String? curve}) async {
    setState(() => isLoading = true);

    final data = await _purchaseOrderConditionService.fetchSKUsReportsxCoverage(
      stPurcharse: widget.stPurcharse,
      cdWarehouseGroupLabel: widget.cdWarehouseGroupLabel,
      curve: curve,
      idGroup: widget.idGroup,
      idFlag: widget.idFlag,
    );

    setState(() {
      _reportsFilteredByCurve = data;
      isLoading = false;

    });
  }

  @override
  Widget build(BuildContext context) {

    final filteredReports = _reportsFilteredByCurve.where((s) =>
      s.codProd.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reporte de SKUs ${widget.stPurcharse == '1' ? 'Con' : 'Sin'} Ordenes de Compra'),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Alinea a la derecha
              children: const [
                Text(
                  'Filtro:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              hint: const Text('Selecciona un tipo'),
              value: _selectedCurve,
              items: const [
                DropdownMenuItem(value: '', child: Text('Todos')),
                DropdownMenuItem(value: 'Y', child: Text('ESENCIAL')),
                DropdownMenuItem(value: 'X', child: Text('NO ESENCIAL')),
                DropdownMenuItem(value: 'Z', child: Text('VITAL')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCurve = newValue;
                });

                fetchData(curve: newValue == '' ? null : newValue);
              },
              isExpanded: true,
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
                              _buildInfoTile('Bandera', report.cdCoverage),
                              _buildInfoTile('Orden', report.descStPurchase),
                              _buildInfoTile('VEN', report.descCurveXyz),
                              _buildInfoTile('Cod. Almacén', report.cdWarehouseGroupLabel),
                              _buildInfoTile('Cod. Producto', report.codProd),
                              _buildInfoTile('Descripción', report.desProd),
                              _buildInfoTile('Unidad de Medida', report.cdMu),
                              _buildInfoTile('OC por Ingresar', report.qtPurchaseOrders.toString()),
                              _buildInfoTile('Unidades por Ingresar', report.qtPurchaseProduct.toString()),
                              _buildInfoTile('Fecha Limite de Ingreso', report.dtEndAsc),
                              _buildInfoTile('Sugerencia de Compra adicional para coberturar 2 meses', report.qtSuggestionEnd.toString()),
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