import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../widgets/customAppBar.dart';

class SeguimientoScreen extends StatefulWidget {
  const SeguimientoScreen({super.key});

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _historial = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistorial();
  }

  Future<void> _fetchHistorial() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      final data = await _supabase
          .from('stress_assessments')
          .select()
          .eq('user_id', userId as Object)
          .order('creado_el', ascending: true);

      setState(() {
        _historial = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      // print("Error cargando historial: $e");
      (e);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: CustomAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text(
                    "Inicio",
                    style: TextStyle(color: Colors.black54, fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: const Text(
                    "Perfil",
                    style: TextStyle(color: Colors.black54, fontSize: 20),
                  ),
                ),
              ],
            ),
            Image.asset('assets/logo_stressting.png', height: 65),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Seguimiento",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildGraficaContainer(),

                  const SizedBox(height: 30),

                  ..._historial.reversed.map(
                    (test) => _buildResultadoItem(test),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildGraficaContainer() {
    return Container(
      height: 250,
      padding: const EdgeInsets.fromLTRB(10, 20, 25, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(25),
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 40,
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < _historial.length) {
                    DateTime fecha = DateTime.parse(
                      _historial[index]['creado_el'],
                    );
                    return Text(
                      "${fecha.day}/${fecha.month}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _historial.asMap().entries.map((e) {
                return FlSpot(
                  e.key.toDouble(),
                  e.value['puntaje_total'].toDouble(),
                );
              }).toList(),
              isCurved: true,
              color: Colors.black, // Color del grafico
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.indigo.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultadoItem(Map<String, dynamic> test) {
    DateTime fecha = DateTime.parse(test['creado_el']);
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black87, width: 2),
            ),
            child: Text(
              "${test['puntaje_total']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Estrés ${test['nivel_estres']}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                fechaFormateada,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
