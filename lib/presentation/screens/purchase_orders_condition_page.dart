import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../core/services/purchase_ordes_condition_service.dart';
import '../../data/models/PurcharseData/coverage.criteria.dart';
import '../../data/models/PurcharseData/purcharse.order.dart';
import '../../data/models/PurcharseData/supplying.warehouse.dart';
import '../../data/models/purchase.condition.dart';
import 'purchase/purchase_order_reports_skus.dart';

class PurchaseOrdersConditionPage extends StatefulWidget {
  const PurchaseOrdersConditionPage({super.key});

  @override
  _PurchaseOrdersConditionPageState createState() => _PurchaseOrdersConditionPageState();
}

class _PurchaseOrdersConditionPageState extends State<PurchaseOrdersConditionPage> {
  String? _selectedProductType;
  final _purchaseOrderConditionService = PurchaseOrdersConditionService();

  List<CoverageCriteria> coverageCriteria = [];
  List<PurchaseOrder> purchaseOrder = [];
  List<SupplyingWarehousePurchase> supplyingWarehouse = [];
  List<PurchaseOrderSKUsReportPage> purchaseSKUsData = [];

  late Future<List<PurchaseCondition>> _detailsFuture;
  String? _selectedCoverage;
  String? _selectedCurve;


  bool isLoading = true;
  bool _isLoadingPurchase = false;
  bool isLoadingReport = true;


  


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData({String? idGroup, String? idFlag}) async {
    setState(() => isLoading = true);
    final data = await _purchaseOrderConditionService.fetchDashboardData(idGroup: idGroup, idFlag: idFlag);
    setState(() {
      coverageCriteria = data['coverageCriteria'];
      purchaseOrder = data['purchaseOrder'];
      supplyingWarehouse = data['supplyingWarehouse'];
      isLoading = false;

    });
  }

  @override
  Widget build(BuildContext context) {
    final Color headerBgColor = Colors.indigo;
    final colorOrder =  Color(0xFF1E942D);
    final colorWithoutOrder = Color(0xFFFF0000);

    final bool hayFiltroFlag = 
      (_selectedCoverage != null && _selectedCoverage != '') ||
      ((_selectedProductType != null && _selectedProductType != '') &&
      (_selectedCoverage != null && _selectedCoverage != ''));


    print(hayFiltroFlag);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerBgColor,
        title: const Text(
          'Niveles de Coberturas de SKUs en los Almacenes Suministradores',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filtro:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        hint: const Text('Selecciona un tipo de producto'),
                        value: _selectedProductType,
                        items: const [
                          DropdownMenuItem(value: '1', child: Text('MEDICINA COMPLEMENTARIA')),
                          DropdownMenuItem(value: '2', child: Text('MEDICAMENTOS')),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedProductType = newValue;
                            _selectedCoverage = null;
                            purchaseOrder = [];
                            coverageCriteria = [];
                            supplyingWarehouse = [];
                            isLoading = true;
                          });

                          fetchData(idGroup: newValue == '' ? null : newValue);
                        },
                        isExpanded: true,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedProductType = null;
                            purchaseOrder = [];
                            coverageCriteria = [];
                            supplyingWarehouse = [];
                            _selectedCoverage = null;
                          });
                          fetchData(); // sin filtros
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Limpiar Filtros'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 136, 152, 223), foregroundColor: const Color.fromARGB(242, 7, 7, 7)),
                      ),
                    ],
                  ),
                  // TOTAL + GRAFICO DONA
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'TOTAL SKUs: ${purchaseOrder.fold<int>(0, (sum, item) => sum + item.qtFlagPurchase)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 300,
                          child: SfCircularChart(
                            legend: Legend(
                              isVisible: false, // Ocultamos leyenda automática
                            ),
                            annotations: <CircularChartAnnotation>[
                              CircularChartAnnotation(
                                widget: Text(
                                  'Total\n' 
                                  'SKUs\n${purchaseOrder.fold<int>(0, (sum, item) => sum + item.qtFlagPurchase)}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                            series: <DoughnutSeries<PurchaseOrder, String>>[
                              DoughnutSeries<PurchaseOrder, String>(
                                dataSource: purchaseOrder,
                                xValueMapper: (data, _) => data.stPurchaseDesc,
                                yValueMapper: (data, _) => data.qtFlagPurchase,
                                pointColorMapper: (data, _) =>
                                    data.stPurchase == 1 ? colorOrder : colorWithoutOrder,
                                dataLabelSettings: const DataLabelSettings(isVisible: true),
                                radius: '80%',
                                innerRadius: '60%',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: colorOrder,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text('Con Orden de Compra'),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: colorWithoutOrder,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text('Sin Orden de Compra'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      color: Colors.indigo,
                      child: const Text(
                        'CRITERIO DE COBERTURA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // BARRA DE COBERTURAS
                    SfCartesianChart(
                    margin: const EdgeInsets.all(30),
                    primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries<CoverageCriteria, String>>[
                      BarSeries<CoverageCriteria, String>(
                        dataSource: coverageCriteria,
                        xValueMapper: (wc, _) => wc.cdCoverage,
                        yValueMapper: (wc, _) => wc.qtFlagStock,
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                        width: 0.3,
                        pointColorMapper: (wc, _) => _hexToColor(wc.idColour1),
                        isTrackVisible: true,
                        onPointTap: (ChartPointDetails details) async {
                          final tappedCoverage = coverageCriteria[details.pointIndex!];
                          final idFlag = tappedCoverage.idFlag.toString();
                          final idGroup = _selectedProductType;
                          debugPrint('idGroup extraído: $idGroup');
                          debugPrint('idFlag extraído: $idFlag');

                          setState(() {
                            _isLoadingPurchase = true;
                            supplyingWarehouse = [];
                            purchaseOrder = [];
                            _selectedCoverage = idFlag;
                          });
                          try {
                            List<SupplyingWarehousePurchase> newSupplyingWarehouse  = [];
                            List<PurchaseOrder> newPurchaseOrder = [];

                            final response = _selectedProductType == null
                                ? await _purchaseOrderConditionService.fetchDashboardData(idFlag: idFlag)
                                : await _purchaseOrderConditionService.fetchDashboardData(idFlag: idFlag, idGroup: idGroup);

                            newSupplyingWarehouse = response['supplyingWarehouse'] ?? [];
                            newPurchaseOrder = response['purchaseOrder'] ?? [];
                            
                              setState(() {
                                supplyingWarehouse = newSupplyingWarehouse;
                                purchaseOrder = newPurchaseOrder;
                              });
                          } catch (e) {
                            debugPrint('Error cargando almacenes suministradores y ordenes de compra: $e');
                          } finally {
                            setState(() {
                              _isLoadingPurchase = false;
                            });
                          }
                        }
                      )
                    ],
                  ),
                  if (supplyingWarehouse.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      color: Colors.indigo,
                      child: const Text(
                        'Almacenes Suministradores',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: supplyingWarehouse.map((supplyingWarehouseDetails) {
                        debugPrint('== DEBUG VALORES DONA ==');
                        debugPrint('qtWarehouseStock: ${supplyingWarehouseDetails.qtWarehouseStock}');
                        debugPrint('qtFlagPurchase: ${supplyingWarehouseDetails.qtFlagPurchase}');
                        debugPrint('idFlag: $_selectedCoverage');
                        debugPrint('idGroup: $_selectedProductType');
                        debugPrint('hayFiltroFlag: $hayFiltroFlag');
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 24, // dos por fila
                          child: Column(
                            children: [
                              Text(
                                supplyingWarehouseDetails.cdWarehouseGroupLabel,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                supplyingWarehouseDetails.dsWarehouse,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '(${supplyingWarehouseDetails.qtWarehouseStock} SKUs)',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 200,
                                child: SfCircularChart(
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                      widget: Text(
                                        hayFiltroFlag
                                            ? '${supplyingWarehouseDetails.qtFlagPurchase}'
                                            : '${supplyingWarehouseDetails.qtWarehouseStock}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                  series: <DoughnutSeries<_DoughnutData, String>>[
                                    DoughnutSeries<_DoughnutData, String>(
                                      dataSource: [
                                        _DoughnutData('Stock', supplyingWarehouseDetails.qtFlagPurchase0),
                                        _DoughnutData('Restante', supplyingWarehouseDetails.qtFlagPurchase1),
                                      ],
                                      xValueMapper: (d, _) => d.label,
                                      yValueMapper: (d, _) => d.value,
                                      pointColorMapper: (d, i) => i == 0
                                          ? _hexToColor(supplyingWarehouseDetails.idColour2)
                                          : _hexToColor(supplyingWarehouseDetails.idColour1),
                                      radius: '80%',
                                      innerRadius: '60%',
                                      dataLabelSettings: const DataLabelSettings(isVisible: false),
                                      onPointTap: (ChartPointDetails details) async {
                                        setState(() => isLoadingReport = true);
                                        final stPurcharse = details.pointIndex == 0 ? 0 : 1;
                                        final idGroup = _selectedProductType;
                                        final idFlag = _selectedCoverage;
                                        final curve = _selectedCurve;
                                        debugPrint('idGroup extraído: $idGroup');
                                        debugPrint('idFlag extraído: $idFlag');
                                        debugPrint('curve extraído: $curve');
                                        
                                        try {
                                          final reports = await _purchaseOrderConditionService.fetchSKUsReportsxCoverage(
                                            stPurcharse: stPurcharse.toString(),
                                            cdWarehouseGroupLabel: supplyingWarehouseDetails.cdWarehouseGroupLabel,
                                            curve: _selectedCurve,
                                            idFlag: _selectedCoverage?.toString(),
                                            idGroup: _selectedProductType?.toString(),
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
                                              builder: (context) => PurchaseOrderSKUsReportPage(
                                                reports: reports, 
                                                stPurcharse: stPurcharse.toString(),
                                                cdWarehouseGroupLabel: supplyingWarehouseDetails.cdWarehouseGroupLabel,
                                                idFlag: _selectedCoverage?.toString(),
                                                idGroup: _selectedProductType?.toString(),
                                                curve: _selectedCurve,
                                                ),
                                            ),
                                          );
                                        } catch (e, stackTrace) {
                                          debugPrint('❌ Error al obtener el detalle: $e');
                                          debugPrint('🧵 StackTrace: $stackTrace');

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Error al obtener el detalle')),
                                          );
                                        } finally {
                                          setState(() => isLoadingReport = false);
                                        }
                                      },

                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  ]
                ],
              ),
            ),
    );
  }

  Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }
  
}

class _DoughnutData {
  final String label;
  final int value;

  _DoughnutData(this.label, this.value);
}