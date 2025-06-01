import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapaFarmaciasPage extends StatefulWidget {
  const MapaFarmaciasPage({super.key});

  @override
  State<MapaFarmaciasPage> createState() => _MapaFarmaciasPageState();
}

class _MapaFarmaciasPageState extends State<MapaFarmaciasPage> {
  LatLng? currentLocation;
  List<Marker> pharmacyMarkers = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initMapAndPharmacies();
  }

  Future<void> _initMapAndPharmacies() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      await _determinePosition();
      if (currentLocation != null) {
        await _searchPharmacies(currentLocation!.latitude, currentLocation!.longitude);
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erro: ${e.toString()}';
      });
      print('Erro ao inicializar o mapa e farmácias: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviços de localização desabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissões de localização negadas.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissões de localização permanentemente negadas. Habilite nas configurações do dispositivo.');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _searchPharmacies(double lat, double lng) async {
    // Consulta Overpass QL para farmácias (amenity=pharmacy) num raio de 5km
    // around:5000 significa 5000 metros (5km)
    final String overpassQuery = '''
       [out:json];
  (
    // Busca por amenity=pharmacy (o padrão para farmácias)
    node(around:5000,$lat,$lng)["name"~"drogaria|farmacia|farmácia",i];
    way(around:5000,$lat,$lng)["name"~"drogaria|farmacia|farmácia",i];
    relation(around:5000,$lat,$lng)["name"~"drogaria|farmacia|farmácia",i];

    node(around:5000,$lat,$lng)[amenity=pharmacy];
    way(around:5000,$lat,$lng)[amenity=pharmacy];
    relation(around:5000,$lat,$lng)[amenity=pharmacy];

    // Busca por healthcare=pharmacy (tag mais específica de saúde)
    node(around:5000,$lat,$lng)[healthcare=pharmacy];
     way(around:5000,$lat,$lng)[healthcare=pharmacy];
relation(around:5000,$lat,$lng)[healthcare=pharmacy];

    node(around:5000,$lat,$lng)["name"~"drogaria|farmacia|farmácia",i];
     way(around:5000,$lat,$lng)["name"~"drogaria|farmacia|farmácia",i];
relation(around:5000,$lat,$lng)["name"~"drogaria|farmacia|farmácia",i];

    // Busca por shop=chemist (pode pegar algumas drogarias ou lojas de produtos químicos)
    node(around:5000,$lat,$lng)[shop=chemist];
     way(around:5000,$lat,$lng)[shop=chemist];
relation(around:5000,$lat,$lng)[shop=chemist];

    // Busca por nomes que contenham "drogaria", "farmacia" ou "farmácia" (case-insensitive)
    node(around:5000,$lat,$lng)["name"~"drogaria|farmacia|farmácia",i];
     way(around:5000,$lat,$lng)["name"~"drogaria|farmacia|farmácia",i];
relation(around:5000,$lat,$lng)["name"~"drogaria|farmacia|farmácia",i];
  );
  out center;
    ''';

    final response = await http.post(
      Uri.parse('https://overpass-api.de/api/interpreter'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: overpassQuery,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Marker> newMarkers = [];

      for (var element in data['elements']) {
        LatLng position;
        String name = element['tags']['name'] ?? 'Farmácia Desconhecida';
        String address = element['tags']['addr:street'] ?? '';
        if (element['tags']['addr:housenumber'] != null) {
          address += ' ${element['tags']['addr:housenumber']}';
        }
        if (address.isEmpty) {
          address = element['tags']['address'] ?? 'Endereço Desconhecido';
        }

        if (element['type'] == 'node') {
          position = LatLng(element['lat'], element['lon']);
        } else if (element['type'] == 'way' || element['type'] == 'relation') {
          // Ways e relations podem ter um 'center' se a consulta usar 'out center;'
          if (element.containsKey('center')) {
            position = LatLng(element['center']['lat'], element['center']['lon']);
          } else {
            // Se não tiver centro, use o primeiro nó ou pule
            continue; // Pula elementos sem centro definido na consulta
          }
        } else {
          continue; // Ignora outros tipos de elementos
        }

        newMarkers.add(
          Marker(
            point: position,
            width: 80.0,
            height: 80.0,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(name),
                      content: Text(address),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Fechar'),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.local_pharmacy, color: Colors.red[700], size: 40.0),
            ),
            // Você pode adicionar um onTap para mostrar mais detalhes
            // builder: (context) => Icon(Icons.location_on, color: Colors.blueAccent),
            // Adicionar um onTap para exibir um AlertDialog ou ir para outra tela
          ),
        );
      }
      setState(() {
        pharmacyMarkers = newMarkers;
      });
    } else {
      throw Exception('Falha ao carregar farmácias: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmácias Próximas (OSM)'),
        backgroundColor: Colors.green[700],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _initMapAndPharmacies,
                          child: Text('Tentar Novamente'),
                        ),
                      ],
                    ),
                  ),
                )
              : currentLocation == null
                  ? const Center(child: Text('Não foi possível obter a localização.'))
                  : FlutterMap(
                      options: MapOptions(
                        initialCenter: currentLocation!,
                        initialZoom: 14.0, // Zoom mais próximo para ver farmácias
                        minZoom: 3.0,
                        maxZoom: 18.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.farmacianoprox', // Importante para boas práticas do OSM
                          // Você pode experimentar outros provedores de tiles como:
                          // urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
                          // subdomains: ['a', 'b', 'c'], // Se o provedor usar subdomínios
                        ),
                        MarkerLayer(
                          markers: [
                            // Marcador da localização atual do usuário
                            Marker(
                              point: currentLocation!,
                              width: 80.0,
                              height: 80.0,
                              child: Icon(
                                Icons.my_location,
                                color: Colors.blueAccent,
                                size: 40.0,
                              ),
                              rotate: true, // Gira o ícone com o mapa
                            ),
                            // Marcadores das farmácias
                            ...pharmacyMarkers,
                          ],
                        ),
                      ],
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _initMapAndPharmacies,
        child: Icon(Icons.refresh),
        backgroundColor: Colors.green,
      ),
    );
  }
}
