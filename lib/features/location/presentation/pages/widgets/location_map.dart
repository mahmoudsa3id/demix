import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/location_coordinate.dart';
import '../../../domain/entities/service_zone.dart';
import 'location_center_pin.dart';

class LocationMap extends StatelessWidget {
  const LocationMap({
    super.key,
    required this.initialCenter,
    required this.onCameraChanged,
    required this.mapController,
    required this.deviceLocation,
    required this.zone,
  });

  final LocationCoordinate initialCenter;
  final ValueChanged<LocationCoordinate> onCameraChanged;
  final MapController mapController;
  final LocationCoordinate deviceLocation;
  final ServiceZone? zone;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: LatLng(
              initialCenter.latitude,
              initialCenter.longitude,
            ),
            initialZoom: 15,
            minZoom: 10,
            maxZoom: 19,
            onPositionChanged: (camera, hasGesture) {
              if (!hasGesture) return;
              onCameraChanged(
                LocationCoordinate(
                  latitude: camera.center.latitude,
                  longitude: camera.center.longitude,
                ),
              );
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.demix_new',
              maxZoom: 19,
            ),
            if (zone != null)
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: zone!.polygon
                        .map((p) => LatLng(p.latitude, p.longitude))
                        .toList(),
                    color: AppColors.primary.withOpacity(.16),
                    borderColor: AppColors.primary,
                    borderStrokeWidth: 3,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    deviceLocation.latitude,
                    deviceLocation.longitude,
                  ),
                  width: 28,
                  height: 28,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.info,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(blurRadius: 8, color: Colors.black26),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        const LocationCenterPin(),
      ],
    );
  }
}
