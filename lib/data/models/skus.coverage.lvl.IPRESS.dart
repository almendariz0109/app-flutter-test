import 'IPRESS_Data/Criterion.dart';
import 'IPRESS_Data/coverageList.dart';
import 'IPRESS_Data/ipress.dart';

class SKUsCoverageIPRESS {
  final List<WarehouseCoverageList> warehouseCoverage;
  final List<CoverageCriterion> coverageCriteria;
  final List<IPRESSStockData> ipressStock;

  SKUsCoverageIPRESS({
    required this.warehouseCoverage,
    required this.coverageCriteria,
    required this.ipressStock,
  });

  factory SKUsCoverageIPRESS.fromJson(Map<String, dynamic> json) {
    return SKUsCoverageIPRESS(
      warehouseCoverage: (json['warehouseCoverage'] as List)
          .map((e) => WarehouseCoverageList.fromJson(e))
          .toList(),
      coverageCriteria: (json['coverageCriteria'] as List)
          .map((e) => CoverageCriterion.fromJson(e))
          .toList(),
      ipressStock: (json['ipressStock'] as List)
          .map((e) => IPRESSStockData.fromJson(e))
          .toList(),
    );
  }
}