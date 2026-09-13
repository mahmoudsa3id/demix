import 'package:geolocator/geolocator.dart';

class LocationDeviceDataSource {
  Future<Position> getCurrentPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw const LocationServiceDisabledException();

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const PermissionDeniedException();
    }

    if (permission == LocationPermission.deniedForever) {
      throw const PermissionDeniedForeverException();
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
    } on LocationServiceDisabledException {
      rethrow;
    } catch (e) {
      throw LocationGpsException(e);
    }
  }
}

class LocationServiceDisabledException implements Exception {
  const LocationServiceDisabledException();
}

class PermissionDeniedException implements Exception {
  const PermissionDeniedException();
}

class PermissionDeniedForeverException implements Exception {
  const PermissionDeniedForeverException();
}

class LocationGpsException implements Exception {
  const LocationGpsException(this.cause);
  final Object cause;
}
