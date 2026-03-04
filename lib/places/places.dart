import 'dart:convert';
import 'package:flutter/services.dart';

class Place {
  final String country;
  final String city;
  final String label;
  final double lat;
  final double lon;
  final String tzId;

  Place({
    required this.country,
    required this.city,
    required this.label,
    required this.lat,
    required this.lon,
    required this.tzId,
  });

  factory Place.fromJson(Map<String, dynamic> j) => Place(
    country: j['country'],
    city: j['city'],
    label: j['label'],
    lat: (j['lat'] as num).toDouble(),
    lon: (j['lon'] as num).toDouble(),
    tzId: j['tzId'],
  );
}

class PlacesRepository {
  static List<Place>? _cache;

  static Future<List<Place>> loadEuropePlaces() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/places/europe_places.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _cache = list.map(Place.fromJson).toList();
    return _cache!;
  }
}