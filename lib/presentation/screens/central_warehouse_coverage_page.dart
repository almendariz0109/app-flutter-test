import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../core/services/warehouse-coverage-service.dart';
import '../../data/models/warehouse.coverage.dart';
import '../../data/models/supplying.warehouse.dart';
import 'coverage/skus_reports_coverage.dart';

class CentralWarehouseCoveragePage extends StatefulWidget {
  const CentralWarehouseCoveragePage({super.key});

  @override
  State<CentralWarehouseCoveragePage> createState() => _CentralWarehouseCoveragePageState();
}

class _CentralWarehouseCoveragePageState extends State<CentralWarehouseCoveragePage> {

  String? _selectedProductType;
  // WarehouseCoverage? _selectedCoverage;

  final WareHouseService _warehouseService = WareHouseService();
  late Future<List<WarehouseCoverage>> _coverageFuture;

  List<SupplyingWarehouse> _supplyingWarehouses = [];
  bool _isLoadingSupplying = false;

  @override
  void initState() {
    super.initState();
    _coverageFuture = _warehouseService.fetchWarehouseCoverage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,  
        title: const Text('Coberturas en el Almacén Central'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // ComboBox (sin funcionalidad por ahora)
            Row(
              children: [
                const Text(
                  'Filtro:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text('Selecciona un tipo de producto'),
                    value: _selectedProductType,
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Todos')),
                      DropdownMenuItem(value: '1', child: Text('MEDICINA COMPLEMENTARIA')),
                      DropdownMenuItem(value: '2', child: Text('MEDICAMENTOS')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedProductType = newValue;
                        _supplyingWarehouses = [];
                        _coverageFuture = (_selectedProductType == null)
                            ? _warehouseService.fetchWarehouseCoverage()
                            : _warehouseService.fetchCoverageByProduct(idGroup: _selectedProductType);
                      });
                    },
                    isExpanded: true,
                  ),
                ),
              ],
            ),

            // FutureBuilder para mostrar el gráfico
            Expanded(
              child: FutureBuilder<List<WarehouseCoverage>>(
                future: _coverageFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay datos disponibles.'));
                  }

                  final data = snapshot.data!;
                  final totalSKUs = data.fold<double>(0, (sum, item) => sum + item.qtFlagStock);


                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Container(
                          color: Colors.indigo,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          margin: const EdgeInsets.only(top: 20, bottom: 15),
                          child: const Text(
                            'Criterio de Cobertura',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0, bottom: 16.0),
                          child: Text(
                            'TOTAL DE SKUs: ${totalSKUs.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        // Gráfico principal
                        SfCartesianChart(
                          margin: const EdgeInsets.all(30),
                          primaryXAxis: CategoryAxis(),
                          series: <CartesianSeries<WarehouseCoverage, String>>[
                            BarSeries<WarehouseCoverage, String>(
                              dataSource: data,
                              xValueMapper: (wc, _) => wc.cdCoverage,
                              yValueMapper: (wc, _) => wc.qtFlagStock,
                              dataLabelSettings: const DataLabelSettings(isVisible: true),
                              width: 0.3,
                              pointColorMapper: (wc, _) => _hexToColor(wc.idColour1),
                              isTrackVisible: true,
                              onPointTap: (ChartPointDetails details) async {
                                final tappedCoverage = data[details.pointIndex!];
                                final idFlag = tappedCoverage.idFlag.toString();

                                setState(() {
                                  _isLoadingSupplying = true;
                                  _supplyingWarehouses = [];
                                });
                                try {
                                  List<SupplyingWarehouse> result = [];
                                  print('Enviando idFlag: ${idFlag}');

                                  if (_selectedProductType == null) {
                                    result = await _warehouseService.fetchSupplyingWarehouse(idFlag: idFlag);
                                  } else {
                                    result = await _warehouseService.fetchSupplyingWarehousexTypeProduct(
                                      idGroup: _selectedProductType,
                                      idFlag: idFlag,
                                    );
                                  }
                                    setState(() {
                                      _supplyingWarehouses = result;
                                    });
                                } catch (e) {
                                  debugPrint('Error cargando almacenes suministradores: $e');
                                } finally {
                                  setState(() {
                                    _isLoadingSupplying = false;
                                  });
                                }
                              }
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          color: Colors.indigo,
                          child: const Text(
                            'Almacenes Administradores',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_isLoadingSupplying)
                          const Center(child: CircularProgressIndicator())
                        else if (_supplyingWarehouses.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No hay almacenes administradores para esta cobertura.'),
                          )
                        else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: _supplyingWarehouses.map((item) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width / 2 - 24,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        '${item.cdWarehouseGroupLabel} - ${item.dsWarehouse}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text('(${item.qtWarehouseStock} SKUs)'),
                                    const SizedBox(height: 6), // Espacio más compacto
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(123, 245, 245, 245),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: const Offset(0, 4) // Sombra hacia abajo
                                          ),
                                        ],
                                      ),
                                      child: SfCircularChart(
                                        margin: EdgeInsets.zero,
                                        annotations: <CircularChartAnnotation>[
                                          CircularChartAnnotation(
                                            widget: Text(
                                              '${item.sumFlagStock}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                        series: <CircularSeries>[
                                          DoughnutSeries<_DoughnutData, String>(
                                            dataSource: [
                                              _DoughnutData('Stock', item.sumFlagStock),
                                              _DoughnutData('Restante', item.qtWarehouseStock - item.sumFlagStock),
                                            ],
                                            xValueMapper: (d, _) => d.label,
                                            yValueMapper: (d, _) => d.value,
                                            pointColorMapper: (d, i) => i == 0
                                                ? _hexToColor(item.idColour1)
                                                : _hexToColor(item.idColour2),
                                            dataLabelSettings: const DataLabelSettings(isVisible: false),
                                            radius: '80%',
                                            innerRadius: '65%',

                                            onPointTap: (ChartPointDetails details) async {
                                              setState(() {
                                                _isLoadingSupplying = true;
                                              });
                                              try {
                                                final reports = await _warehouseService.fetchSKUsReportsxCoverage(
                                                  cdWarehouseGroupLabel: item.cdWarehouseGroupLabel,
                                                  idFlag: item.idFlag.toString(),
                                                );

                                                if (reports.isEmpty) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('No se encontraron reportes para esta cobertura')),
                                                  );
                                                  return;
                                                }

                                                if (!mounted) return;

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => SKUSReportPage(reports: reports),
                                                  ),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Error al obtener el detalle')),
                                                );
                                              } finally {
                                                setState(() => _isLoadingSupplying = false);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _hexToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}

class _DoughnutData {
  final String label;
  final int value;

  _DoughnutData(this.label, this.value);
}
