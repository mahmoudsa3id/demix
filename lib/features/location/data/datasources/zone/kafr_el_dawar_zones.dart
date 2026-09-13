import '../../../domain/entities/location_coordinate.dart';
import '../../../domain/entities/service_zone.dart';

/// Current DeMiX delivery boundary.
///
/// IMPORTANT: this is a configurable commercial service polygon, not a legal
/// administrative boundary. Replace the points with your real delivery
/// boundary before production if the business area changes.
const List<ServiceZone> demixServiceZones = [
  ServiceZone(
    id: 'kafr_el_dawar',
    name: 'Kafr El Dawar',
    polygon: [
      LocationCoordinate(latitude: 31.1760, longitude: 30.0790),
      LocationCoordinate(latitude: 31.1765, longitude: 30.1370),
      LocationCoordinate(latitude: 31.1610, longitude: 30.1830),
      LocationCoordinate(latitude: 31.1320, longitude: 30.2020),
      LocationCoordinate(latitude: 31.0950, longitude: 30.1820),
      LocationCoordinate(latitude: 31.0820, longitude: 30.1320),
      LocationCoordinate(latitude: 31.0870, longitude: 30.0860),
      LocationCoordinate(latitude: 31.1120, longitude: 30.0610),
      LocationCoordinate(latitude: 31.1450, longitude: 30.0600),
    ],
  ),
];
