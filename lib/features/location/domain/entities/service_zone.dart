import 'location_coordinate.dart';

class ServiceZone {
  const ServiceZone({
    required this.id,
    required this.name,
    required this.polygon,
  });

  final String id;
  final String name;
  final List<LocationCoordinate> polygon;
}

class ServiceZoneMatch {
  const ServiceZoneMatch({
    required this.isInside,
    this.zone,
  });

  final bool isInside;
  final ServiceZone? zone;
}
