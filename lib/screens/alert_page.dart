import 'package:flutter/material.dart';
import '../models/suggestion.dart';
import '../services/alert_service.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final List<String> _months = ['2', '3', '4'];
  final List<String> _products = ['1', '2'];
  final List<String> _curves = ['ESENCIAL', 'VITAL', 'NO VITAL'];

  String? _selectedMonth;
  String? _selectedProduct;
  String? _selectedCurve;

  final AlertService _alertService = AlertService();
  List<Suggestion> _suggestions = [];
  bool _isLoading = false;

  void _fetchSuggestions() async {
    if (_selectedMonth == null || _selectedProduct == null) return;

    setState(() => _isLoading = true);

    try {
      final suggestions = await _alertService.fetchSuggestions(
        months: _selectedMonth!,
        product: _selectedProduct!,
        curve: _selectedCurve ?? '',
      );
      setState(() => _suggestions = suggestions);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener sugerencias')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sugerencia de Compra')),
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
            _buildDropdown('Curva (opcional)', _curves, _selectedCurve, (val) => setState(() => _selectedCurve = val)),

            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _fetchSuggestions,
                child: const Text('Buscar'),
              ),
            ),
            const SizedBox(height: 20),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _suggestions.isEmpty
                    ? const Text('No hay sugerencias')
                    : _buildResultsTable()
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
    return Column(
      children: _suggestions.map((s) => ExpansionTile(
        title: Text(s.desProd),
        subtitle: Text('Curva: ${s.curveXyz} - ${s.descCurveXyz}'),
        children: [
          ListTile(title: Text('Cantidad sugerida: ${s.cdMu}')),
          ListTile(title: Text('Código: ${s.codProd}')),
          ListTile(title: Text('Unidad: ${s.cdMu}')),
          ListTile(title: Text('Meses: ${s.qtMonth}')),
        ],
      )).toList(),
    );
  }
}
