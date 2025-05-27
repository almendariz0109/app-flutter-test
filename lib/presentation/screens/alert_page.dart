import 'package:flutter/material.dart';
import '../../data/models/suggestion.dart';
import '../../core/services/alert_service.dart';
import 'alerts/alert_details_page.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final List<String> _months = ['2', '3', '4'];
  final List<String> _products = ['1', '2'];
  final Map<String, String> _curves = {
    'ESENCIAL': 'Y',
    'VITAL': 'Z',
    'NO VITAL': 'X',
  };

  String? _selectedMonth;
  String? _selectedProduct;
  String? _selectedCurveLabel;

  final AlertService _alertService = AlertService();
  List<Suggestion> _suggestions = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  bool _hasSearched = false;

  final Map<String, bool> _expandedStates = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchSuggestions() async {
    if (_selectedMonth == null || _selectedProduct == null) return;

    setState(() {_isLoading = true; _hasSearched = true;});

    try {
      final suggestions = await _alertService.fetchSuggestions(
        months: _selectedMonth!,
        product: _selectedProduct!,
        curve: _selectedCurveLabel != null ? _curves[_selectedCurveLabel!] ?? '' : '',
      );
      setState(() => _suggestions = suggestions);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener sugerencias')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedMonth = null;
      _selectedProduct = null;
      _selectedCurveLabel = null;
      _searchQuery = '';
      _searchController.clear();
      _hasSearched = false;
      _suggestions.clear();
    });
  }

void _viewDetails(String codProd) async {
  setState(() => _isLoading = true);

  try {
    final details = await _alertService.fetchDetails(codProd: codProd);
    print('Detalles obtenidos: ${details.length}');

    if (details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron detalles para este producto')),
      );
      return; // No navegues si está vacío
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlertDetailsPage(details: details),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al obtener el detalle')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alerta de Sugerencia de Compra',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sugerencia de Compra Adicional para Cobertura Por Meses',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),

            // Dropdowns
            _buildDropdown('Meses', _months, _selectedMonth, (val) => setState(() => _selectedMonth = val)),
            _buildDropdown('Producto', _products, _selectedProduct, (val) => setState(() => _selectedProduct = val)),
            _buildDropdown('Curva (opcional)', _curves.keys.toList(), _selectedCurveLabel, (val) => setState(() => _selectedCurveLabel = val)),

            if (_hasSearched) ...[
              const SizedBox(height: 16),
              // Campo de búsqueda
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Buscar por Código',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim();
                  });
                },
              ),
            ],

            const SizedBox(height: 16),
            // Botones: Buscar y Limpiar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _fetchSuggestions,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text('Buscar'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: _clearFilters,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text('Limpiar'),
                ),
              ],
            ),

            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _suggestions.isEmpty
                    ? const Text('No hay sugerencias')
                    : _buildResultsTable(),
          ],
        ),
      ),
    );
  }

  

  Widget _buildDropdown(String label, List<String> items, String? selected, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selected,
        hint: Text(label),
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildResultsTable() {
    final filtered = _suggestions.where((s) =>
        s.codProd.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    if (filtered.isEmpty) return const Text('No se encontraron coincidencias');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabecera fija
        Container(
          color: Colors.indigo[100],
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: const [
              Expanded(
                flex: 2,
                child: Text(
                  'Código',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Descripción',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 48), // espacio para el botón expandir
            ],
          ),
        ),

        // Lista scrollable con resultados
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final s = filtered[index];
            final isExpanded = _expandedStates[s.codProd] ?? false;

            return Column(
              children: [
                Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text(s.codProd)),
                      Expanded(flex: 3, child: Text(s.desProd)),
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_circle,
                          color: Colors.indigo,
                        ),
                        onPressed: () {
                          setState(() {
                            _expandedStates[s.codProd] = !isExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (isExpanded)
                  Container(
                    color: Colors.grey[50],
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoTile('Unidad', s.cdMu),
                        _buildInfoTile('VEN', s.descCurveXyz),
                        _buildInfoTile('Sug. 0501', s.qtSuggesEnd0501),
                        _buildInfoTile('Sug. 0599', s.qtSuggesEnd0599),
                        _buildInfoTile('Sug. 0601', s.qtSuggesEnd0601),
                        _buildInfoTile('Sug. 0699', s.qtSuggesEnd0699),
                        _buildInfoTile('Sug. 0701', s.qtSuggesEnd0701),
                        _buildInfoTile('Sug. 0799', s.qtSuggesEnd0799),
                        _buildInfoTile('Sug. 9201', s.qtSuggesEnd9201),
                        _buildInfoTile('Sug. 9501', s.qtSuggesEnd9501),
                        _buildInfoTile('Sug. 9907', s.qtSuggesEnd9907),
                        _buildInfoTile('Sugerencia Total', s.qtSuggesEnd.toString()),
                        const SizedBox(height: 8),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => _viewDetails(s.codProd),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: const Text('Ver Detalle'),
                          ),
                        ),
                      ],
                    ),
                  ),
                const Divider(height: 1, color: Colors.grey),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            text: '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
