import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class PharmacyMapState extends ChangeNotifier {
  LatLng? currentLocation;
  List<Marker>? _pharmacyMarkers;
  List<Marker>? get pharmacyMarkers => _pharmacyMarkers;
  bool isLoading = true;
  String errorMessage = '';

  Future<void> initMapAndPharmacies() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await _determinePosition();
      if (currentLocation != null) {
        await _searchPharmacies(currentLocation!.latitude, currentLocation!.longitude);
      }
    } catch (e) {
      errorMessage = 'Erro: ${e.toString()}';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
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

    currentLocation = LatLng(position.latitude, position.longitude);
    notifyListeners();
  }

  Future<void> _searchPharmacies(double lat, double lng) async {
    Dio dio = Dio();

    var overpassQuery = getOverpassQuery(lat, lng);

    final response = await dio.post(
      'https://overpass-api.de/api/interpreter',
      data: {'data': overpassQuery},
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      List<Marker> newMarkers = [];

      for (var element in response.data['elements']) {
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
            child: Builder(builder: (ctx) {
              return GestureDetector(
                onTap: () {
                  showDialog(
                      context: ctx,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(name),
                          content: Text(address),
                          actions: <Widget>[
                            TextButton(child: const Text('Fechar'), onPressed: () => ctx.pop()),
                          ],
                        );
                      });
                },
                child: Icon(Icons.local_pharmacy, color: Colors.red[700], size: 40.0),
              );
            }),
          ),
        );
      }

      _pharmacyMarkers = newMarkers;
      notifyListeners();
    } else {
      throw Exception('Falha ao carregar farmácias: ${response.statusCode}');
    }
  }

  String getOverpassQuery(double lat, double lng) {
    return '''
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
  }
}
