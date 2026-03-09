// lib/models/stop_point.dart
import 'package:latlong2/latlong.dart';

class StopPoint {
  final int id;
  final int routeId;
  final String name;
  final double latitude;
  final double longitude;
  final int orderInRoute;
  final DateTime createdAt;

  StopPoint({
    required this.id,
    required this.routeId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.orderInRoute,
    required this.createdAt,
  });

  factory StopPoint.fromMap(Map<String, dynamic> map) {
    return StopPoint(
      id: map['id'] as int,
      routeId: map['route_id'] as int,
      name: map['name'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      orderInRoute: map['order_in_route'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Convertir a LatLng para flutter_map
  LatLng toLatLng() => LatLng(latitude, longitude);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'route_id': routeId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'order_in_route': orderInRoute,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
