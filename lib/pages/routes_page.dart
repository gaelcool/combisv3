import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Datos de una ruta individual — clase simple, sin dependencia de BD.
/// TODO: Fase 3b — reemplazar con el modelo AppRoute de models/route.dart
class _ItemRuta {
  final String numero;
  final String nombre;
  final String tiempoEstimado;
  final Color color;
  final List<String> paradas;

  const _ItemRuta({
    required this.numero,
    required this.nombre,
    required this.tiempoEstimado,
    required this.color,
    required this.paradas,
  });
}

/// Rutas de ejemplo estáticas para Chiautempan, Tlaxcala.
/// TODO: Fase 3b — cargar desde DatabaseHelper.instance.getAllRoutes()
const List<_ItemRuta> _rutasEjemplo = [
  _ItemRuta(
    numero: 'A',
    nombre: 'Centro → Volcanes',
    tiempoEstimado: '12 min',
    color: AppColors.pumpkinSpice,
    paradas: ['Zócalo', 'Av. Hidalgo', 'Volcanes'],
  ),
  _ItemRuta(
    numero: 'B',
    nombre: 'Escalinatas → Mercado',
    tiempoEstimado: '10 min',
    color: AppColors.princetonOrange,
    paradas: ['Escalinatas', 'Plaza Central', 'Mercado'],
  ),
  _ItemRuta(
    numero: 'C',
    nombre: 'Zócalo → Bienestar',
    tiempoEstimado: '8 min',
    color: AppColors.amberGlow,
    paradas: ['Zócalo', 'Calle Juárez', 'Bienestar'],
  ),
  _ItemRuta(
    numero: 'D',
    nombre: 'Soriana → Sta. Ana',
    tiempoEstimado: '6 min',
    color: AppColors.lavenderPurple,
    paradas: ['Soriana', 'Mercado', 'Sta. Ana'],
  ),
  _ItemRuta(
    numero: 'E',
    nombre: 'Ocotlán → Hospital',
    tiempoEstimado: '7 min',
    color: AppColors.pumpkinSpice,
    paradas: ['Ocotlán', 'Centro', 'Hospital'],
  ),
];

/// Muestra la lista de rutas de combis disponibles.
/// Sin base de datos — solo datos de ejemplo hasta la Fase 3b.
/// Por ahora tendra una busqueda simple de rutas por nombre.
class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  final TextEditingController _controladorBusqueda = TextEditingController();
  List<_ItemRuta> _rutasFiltradas = List.from(_rutasEjemplo);

  void _filtrarRutas(String consulta) {
    setState(() {
      if (consulta.isEmpty) {
        _rutasFiltradas = List.from(_rutasEjemplo);
      } else {
        _rutasFiltradas = _rutasEjemplo.where((ruta) {
          final nombreEnMinusculas = ruta.nombre.toLowerCase();
          final consultaEnMinusculas = consulta.toLowerCase();
          final coincideNombre = nombreEnMinusculas.contains(
            consultaEnMinusculas,
          );

          final coincideParada = ruta.paradas.any(
            (parada) => parada.toLowerCase().contains(consultaEnMinusculas),
          );

          return coincideNombre || coincideParada;
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controladorBusqueda,
              onChanged: _filtrarRutas,
              decoration: InputDecoration(
                hintText: 'Buscar por ruta o parada...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: _rutasFiltradas.length,
              itemBuilder: (context, index) {
                return _TarjetaRuta(ruta: _rutasFiltradas[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaRuta extends StatelessWidget {
  final _ItemRuta ruta;

  const _TarjetaRuta({required this.ruta});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Fase 3b — navegar al detalle de ruta / resaltar en el mapa
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ruta ${ruta.numero} — ${ruta.nombre}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Insignia del número de ruta
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ruta.color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    ruta.numero,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Nombre de la ruta
              Expanded(
                child: Text(
                  ruta.nombre,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              // Chip de tiempo estimado
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 13,
                      color: AppColors.amberGlow,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ruta.tiempoEstimado,
                      style: const TextStyle(
                        color: AppColors.amberGlow,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
