import '../../../domain/entities/location_coordinate.dart';
import '../../../domain/entities/service_zone.dart';
import 'service_zone_checker.dart';

class LocalServiceZoneChecker implements ServiceZoneChecker {
  const LocalServiceZoneChecker(this.zones);

  final List<ServiceZone> zones;

  @override
  Future<ServiceZoneMatch> check(LocationCoordinate point) async {
    for (final zone in zones) {
      if (isPointInPolygon(point, zone.polygon)) {
        return ServiceZoneMatch(isInside: true, zone: zone);
      }
    }

    return const ServiceZoneMatch(isInside: false);
  }

  static bool isPointInPolygon(
    LocationCoordinate point,
    List<LocationCoordinate> polygon,
  ) {
    if (polygon.length < 3) return false;

    var inside = false;

    for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      final a = polygon[i];
      final b = polygon[j];

      if (_isPointOnSegment(point, a, b)) return true;

      final intersects = ((a.latitude > point.latitude) !=
              (b.latitude > point.latitude)) &&
          (point.longitude <
              (b.longitude - a.longitude) *
                      (point.latitude - a.latitude) /
                      (b.latitude - a.latitude) +
                  a.longitude);

      if (intersects) inside = !inside;
    }

    return inside;
  }

  static bool _isPointOnSegment(
    LocationCoordinate p,
    LocationCoordinate a,
    LocationCoordinate b,
  ) {
    const epsilon = 1e-10;

    final cross =
        (p.latitude - a.latitude) * (b.longitude - a.longitude) -
        (p.longitude - a.longitude) * (b.latitude - a.latitude);

    if (cross.abs() > epsilon) return false;

    return p.latitude >= _min(a.latitude, b.latitude) - epsilon &&
        p.latitude <= _max(a.latitude, b.latitude) + epsilon &&
        p.longitude >= _min(a.longitude, b.longitude) - epsilon &&
        p.longitude <= _max(a.longitude, b.longitude) + epsilon;
  }

  static double _min(double a, double b) => a < b ? a : b;
  static double _max(double a, double b) => a > b ? a : b;
}
