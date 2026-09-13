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
    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'format': 'jsonv2',
      'lat': coordinate.latitude.toStringAsFixed(7),
      'lon': coordinate.longitude.toStringAsFixed(7),
      'addressdetails': '1',

      // Important:
      // zoom 18 gives detailed address/road data.
      'zoom': '18',

      'accept-language': languageCode,
    });

    final response = await _client
        .get(
          uri,
          headers: {'User-Agent': userAgent, 'Accept': 'application/json'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw NominatimException('HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const NominatimException('Invalid Nominatim response.');
    }

    final rawAddress = decoded['address'];

    final address = rawAddress is Map<String, dynamic>
        ? rawAddress
        : <String, dynamic>{};

    String? firstNonEmpty(List<dynamic> values) {
      for (final value in values) {
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }

      return null;
    }

    // -----------------------------------------------------------------------
    // REAL STREET / ROAD
    // -----------------------------------------------------------------------

    final street = firstNonEmpty([
      address['road'],
      address['pedestrian'],
      address['residential'],
      address['cycleway'],
      address['footway'],
      address['path'],
    ]);

    // -----------------------------------------------------------------------
    // IMPORTANT
    //
    // Don't accept raw GPS coordinates as an address.
    // If Nominatim can't identify an actual road/street,
    // the selected location is not valid for delivery selection.
    // -----------------------------------------------------------------------

    if (street == null) {
      throw const NoStreetAddressException();
    }

    final houseNumber = firstNonEmpty([address['house_number']]);

    final city = firstNonEmpty([
      address['city'],
      address['town'],
      address['municipality'],
      address['village'],
    ]);

    final area = firstNonEmpty([
      address['suburb'],
      address['neighbourhood'],
      address['quarter'],
      address['district'],
      address['city_district'],
    ]);

    final country = firstNonEmpty([address['country']]);

    // -----------------------------------------------------------------------
    // Build a cleaner display address.
    //
    // Prefer:
    // house number + street + area + city
    //
    // This gives the user an actual readable delivery address.
    // -----------------------------------------------------------------------

    final parts = <String>[];

    if (houseNumber != null) {
      parts.add(houseNumber);
    }

    parts.add(street);

    if (area != null) {
      parts.add(area);
    }

    if (city != null) {
      parts.add(city);
    }

    if (country != null) {
      parts.add(country);
    }

    final formattedAddress = parts.join(', ');

    return LocationModel(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude,
      country: country,
      city: city,
      area: area,
      street: street,
      formattedAddress: formattedAddress.isNotEmpty
          ? formattedAddress
          : decoded['display_name'] as String?,
      isInsideZone: false,
    );
  }

  void dispose() {
    _client.close();
  }
}

class NominatimException implements Exception {
  const NominatimException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NoStreetAddressException implements Exception {
  const NoStreetAddressException();

  @override
  String toString() => 'No street address was found for this location.';
}
