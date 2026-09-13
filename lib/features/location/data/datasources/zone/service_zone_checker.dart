import '../../../domain/entities/location_coordinate.dart';
import '../../../domain/entities/service_zone.dart';

abstract interface class ServiceZoneChecker {
  Future<ServiceZoneMatch> check(LocationCoordinate point);
}
