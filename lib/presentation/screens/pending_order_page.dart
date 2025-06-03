import 'package:flutter/material.dart';
import '../../data/models/pending.order.dart';
import '../../core/services/pending_order_service.dart';

class PendingOrderPage extends StatefulWidget {
  const PendingOrderPage({super.key});

  @override
  State<PendingOrderPage> createState() => _PedingOrderState();
}

class _PedingOrderState extends State<PendingOrderPage> {

  final PendingOrderService _pendingOrderService = PendingOrderService();
  List<PendingOrder> _orders = [];
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

  void _fetchPendingOrder() async {
    setState(() {_isLoading = true; _hasSearched = true;});
    try {
      final orders = await _pendingOrderService.fetchPendingOrder();
      setState(() => _orders = orders);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener las ordenes')),
      );
    } finally {
      setState(() => _isLoading = false);
    }  
  }

  @override
  void initState() {
    super.initState();
    _fetchPendingOrder(); // Llama automáticamente al cargar la página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
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
              'Órdenes de Compra Pendientes de Ingreso',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),

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

            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _orders.isEmpty
                    ? const Text('No hay ordenes')
                    : _buildResultsTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsTable() {
    final filtered = _orders.where((s) =>
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
                        _buildInfoTile('Código de Almacen', s.codWareHouse),
                        _buildInfoTile('Código de Producto', s.codProd),
                        _buildInfoTile('Descripción', s.desProd),
                        _buildInfoTile('Unidad de Medida', s.cdMu),
                        _buildInfoTile('VEN', s.descCurveXyzc),
                        _buildInfoTile('Unidades por Ingresar', s.qtPurchaseProduct.toString()),
                        _buildInfoTile('OC por Ingresar', s.qtPurchaseOrders.toString()),
                        _buildInfoTile('Bandera', s.cdCoverage),
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
