import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../domain/entities/location_coordinate.dart';
import '../../models/location_model.dart';

class NominatimGeocodingDataSource {
  NominatimGeocodingDataSource({
    required this.userAgent,
    this.languageCode = 'en',
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String userAgent;
  final String languageCode;
  final http.Client _client;

  Future<LocationModel> reverse(LocationCoordinate coordinate) async {
    final uri = Uri.https(
      'nominatim.openstreetmap.org',
      '/reverse',
      {
        'format': 'jsonv2',
        'lat': coordinate.latitude.toStringAsFixed(7),
        'lon': coordinate.longitude.toStringAsFixed(7),
        'addressdetails': '1',
        'zoom': '18',
        'accept-language': languageCode,
      },
    );

    final response = await _client.get(
      uri,
      headers: {
        'User-Agent': userAgent,
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw NominatimException('HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const NominatimException('Invalid response');
    }

    final rawAddress = decoded['address'];
    final address = rawAddress is Map<String, dynamic>
        ? rawAddress
        : <String, dynamic>{};

    String? firstNonEmpty(List<dynamic> values) {
      for (final value in values) {
        if (value is String && value.trim().isNotEmpty) return value.trim();
      }
      return null;
    }

    return LocationModel(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude,
      country: address['country'] as String?,
      city: firstNonEmpty([
        address['city'],
        address['town'],
        address['municipality'],
        address['village'],
      ]),
      area: firstNonEmpty([
        address['suburb'],
        address['neighbourhood'],
        address['quarter'],
        address['district'],
        address['city_district'],
      ]),
      street: firstNonEmpty([
        address['road'],
        address['pedestrian'],
        address['residential'],
      ]),
      formattedAddress: decoded['display_name'] as String?,
      isInsideZone: false,
    );
  }

  void dispose() => _client.close();
}

class NominatimException implements Exception {
  const NominatimException(this.message);
  final String message;

  @override
  String toString() => message;
}
