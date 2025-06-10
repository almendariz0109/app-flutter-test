import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../core/services/skus-coverage-IPRESS.-service.dart';
import '../../data/models/IPRESS_Data/coverageList.dart';
import '../../data/models/IPRESS_Data/criterion.dart';
import '../../data/models/IPRESS_Data/ipress.dart';
import '../../data/models/IPRESS_Data/ipressDetails.dart';
import '../../data/models/skus.coverage.lvl.IPRESS.dart';
import 'ipress/ipress_report_skus.dart';

class SKUsCoverageIPRESSPage extends StatefulWidget {
  const SKUsCoverageIPRESSPage({super.key});

  @override
  _SKUsCoverageIPRESSPageState createState() => _SKUsCoverageIPRESSPageState();
}

class _SKUsCoverageIPRESSPageState extends State<SKUsCoverageIPRESSPage> {
  String? _selectedProductType;
  final _skusCoverageIPRESSService = SKUsCoverageIPRESSService();

  List<WarehouseCoverageList> warehouseCoverage = [];
  List<CoverageCriterion> coverageCriteria = [];
  List<IPRESSStockData> ipressStockData = [];
  List<IPRESSDetails> ipressDetailsData = [];

  late Future<List<SKUsCoverageIPRESS>> _detailsFuture;

  String _selectedWarehouse = '';
  bool isLoading = true;
  bool _isLoadingIPRESS = false;
  bool isLoadingReport = true;


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData({String? cdWarehouseGroupLabel, String? idGroup}) async {
    setState(() => isLoading = true);
    final data = await _skusCoverageIPRESSService.fetchDashboardData(cdWarehouseGroupLabel: cdWarehouseGroupLabel, idGroup: idGroup);
    setState(() {
      warehouseCoverage = data['warehouseCoverage'];
      coverageCriteria = data['coverageCriteria'];
      ipressStockData = data['ipressStock'];
      _selectedWarehouse = cdWarehouseGroupLabel ?? '';
      isLoading = false;
    });
  }

  Future<void> fetchDataDetails({required String cdWarehouseGroupLabel, required String idFlag, String? idGroup}) async {
    setState(() => isLoading = true);
    final data = await _skusCoverageIPRESSService.fetchDashboardIPRESSDetails(cdWarehouseGroupLabel: cdWarehouseGroupLabel, idFlag: idFlag, idGroup: idGroup);
    setState(() {
      ipressDetailsData = data['ipressDetailsData'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color headerBgColor = Colors.indigo;
    final colorBgDonut =  Color(0xFF34495E);
    final colorDonut = Color(0xFF9BB0C5);

    final List<IPRESSStockData> chartData = _selectedWarehouse.isEmpty ? 
    [
      IPRESSStockData(
        cdWarehouseGroupLabel: 'Sin Datos',
        dsEstab: 'sin datos',
        qtWarehouseStock: 1,
        totalStock: 1,
      )
    ] : ipressStockData;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerBgColor,
        title: const Text(
          'Niveles de Coberturas de SKUs en la IPRESS',
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
                            warehouseCoverage = [];
                            coverageCriteria = [];
                            ipressStockData = [];
                            ipressDetailsData = []; // limpiar gráficos IPRESS al cambiar producto
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
                            warehouseCoverage = [];
                            coverageCriteria = [];
                            ipressStockData = [];
                            ipressDetailsData = []; // limpiar gráficos IPRESS al limpiar filtros
                          });
                          fetchData(); // sin filtros
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Limpiar Filtros'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      ),
                    ],
                  ),
                  // TOTAL + GRAFICO DONA
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'TOTAL: ${ipressStockData.isNotEmpty ? ipressStockData.first.totalStock : 0} SKUs',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        if (_selectedWarehouse.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${ipressStockData.first.cdWarehouseGroupLabel} - ${ipressStockData.first.dsEstab}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        SizedBox(
                          height: 300,
                          child: SfCircularChart(
                            legend: Legend(
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                              position: LegendPosition.bottom,
                            ),
                            annotations: <CircularChartAnnotation>[
                              CircularChartAnnotation(
                                widget: Text(
                                  ipressStockData.isEmpty
                                      ? '0'
                                      : _selectedWarehouse.isEmpty
                                          ? '${ipressStockData.first.totalStock}'
                                          : '${ipressStockData.first.qtWarehouseStock}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                              ),
                            ],
                            series: <DoughnutSeries<IPRESSStockData, String>>[
                              DoughnutSeries<IPRESSStockData, String>(
                                dataSource: chartData,
                                xValueMapper: (data, _) => data.cdWarehouseGroupLabel,
                                yValueMapper: (data, _) => data.qtWarehouseStock,
                                pointColorMapper: (data, _) => _selectedWarehouse.isEmpty ? colorDonut : colorBgDonut,
                                dataLabelSettings: const DataLabelSettings(isVisible: false),
                                radius: '80%',
                                innerRadius: '60%',
                              ),
                            ],
                          ),
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
                        '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: warehouseCoverage.map((w) {
                      final bgColor = _hexToColor(w.bgColor);
                      final textColor = _hexToColor(w.color);
                      return GestureDetector(
                        onTap: () => fetchData(cdWarehouseGroupLabel: w.cdWarehouseGroupLabel, idGroup: _selectedProductType),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${w.cdWarehouseGroupLabel} - ${w.dsEstab}\n'
                            '            ${w.qtWarehouseStock} SKUs',
                            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
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
                    series: <CartesianSeries<CoverageCriterion, String>>[
                      BarSeries<CoverageCriterion, String>(
                        dataSource: coverageCriteria,
                        xValueMapper: (wc, _) => wc.cdCoverage,
                        yValueMapper: (wc, _) => wc.qtFlagStock,
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                        width: 0.3,
                        pointColorMapper: (wc, _) => _hexToColor(wc.idColour1),
                        isTrackVisible: true,
                        onPointTap: (ChartPointDetails details) async {
                            if (_selectedWarehouse.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Por favor, seleccione un almacén primero.')),
                              );
                              return;
                            }
                          final tappedCoverage = coverageCriteria[details.pointIndex!];
                          final idFlag = tappedCoverage.idFlag.toString();
                          final cdWarehouseGroupLabel = _selectedWarehouse;
                          final idGroup = _selectedProductType;
                          debugPrint('idGroup extraído: $idGroup');

                          setState(() {
                            _isLoadingIPRESS = true;
                            ipressDetailsData = [];
                          });
                          try {
                            List<IPRESSDetails> result = [];

                            if (_selectedProductType == null) {
                              final response = await _skusCoverageIPRESSService.fetchDashboardIPRESSDetails(idFlag: idFlag, cdWarehouseGroupLabel: cdWarehouseGroupLabel);
                              result = response['ipressDetailsData'] ?? [];
                            }else {
                              final response = await _skusCoverageIPRESSService.fetchDashboardIPRESSDetails(idFlag: idFlag, cdWarehouseGroupLabel: cdWarehouseGroupLabel, idGroup: idGroup);
                              result = response['ipressDetailsData'] ?? [];
                            }
                            
                              setState(() {
                                ipressDetailsData = result;
                              });
                          } catch (e) {
                            debugPrint('Error cargando detalle de IPRESS: $e');
                          } finally {
                            setState(() {
                              _isLoadingIPRESS = false;
                            });
                          }
                        }
                      )
                    ],
                  ),
                  if (ipressDetailsData.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      color: Colors.indigo,
                      child: const Text(
                        'IPRESS',
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
                      children: ipressDetailsData.map((ipressDetail) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 24, // dos por fila
                          child: Column(
                            children: [
                              Text(
                                ipressDetail.cdWarehouse,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                ipressDetail.dsWarehouse,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '(${ipressDetail.qtWarehouseStock} SKUs)',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 200,
                                child: SfCircularChart(
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                      widget: Text(
                                        '${ipressDetail.qtFlagStock}',
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
                                        _DoughnutData('Stock', ipressDetail.qtFlagStock),
                                        _DoughnutData('Restante', ipressDetail.qtWarehouseStock - ipressDetail.qtFlagStock),
                                      ],
                                      xValueMapper: (d, _) => d.label,
                                      yValueMapper: (d, _) => d.value,
                                      pointColorMapper: (d, i) => i == 0
                                          ? _hexToColor(ipressDetail.idColour1)
                                          : _hexToColor(ipressDetail.idColour2),
                                      radius: '80%',
                                      innerRadius: '60%',
                                      dataLabelSettings: const DataLabelSettings(isVisible: false),
                                      onPointTap: (ChartPointDetails details) async {
                                        setState(() => isLoadingReport = true);
                                        try {
                                          final reports = await _skusCoverageIPRESSService.fetchSKUsReportsxCoverage(
                                            cdWarehouse: ipressDetail.cdWarehouse,
                                            idFlag: ipressDetail.idFlag.toString(),
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
                                              builder: (context) => IPRESSReportPage(reports: reports),
                                            ),
                                          );
                                        } catch (e) {
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
