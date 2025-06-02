import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:meditrack/screens/maps/state.dart';

class PharmacyMapScreen extends StatefulWidget {
  const PharmacyMapScreen({super.key});

  @override
  State<PharmacyMapScreen> createState() => _PharmacyMapScreenState();
}

class _PharmacyMapScreenState extends State<PharmacyMapScreen> {
  final state = PharmacyMapState();

  @override
  void initState() {
    super.initState();
    state.initMapAndPharmacies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farmácias Próximas (OSM)'), backgroundColor: Colors.green[700]),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: state,
          builder: (context, _) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.errorMessage.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.errorMessage,
                          textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontSize: 16)),
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: state.initMapAndPharmacies, child: const Text('Tentar Novamente')),
                    ],
                  ),
                ),
              );
            } else if (state.currentLocation == null) {
              return const Center(child: Text('Não foi possível obter a localização.'));
            } else {
              return FlutterMap(
                options: MapOptions(
                    initialCenter: state.currentLocation!,
                    initialZoom: 14.0, // Zoom mais próximo para ver farmácias
                    minZoom: 3.0,
                    maxZoom: 18.0),
                children: [
                  TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.farmacianoprox'),
                  MarkerLayer(
                    markers: [
                      Marker(
                          point: state.currentLocation!,
                          width: 80.0,
                          height: 80.0,
                          child: const Icon(Icons.my_location, color: Colors.blueAccent, size: 40.0),
                          rotate: true),
                      ...state.pharmacyMarkers ?? [],
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: state.initMapAndPharmacies, backgroundColor: Colors.green, child: const Icon(Icons.refresh)),
    );
  }
}
