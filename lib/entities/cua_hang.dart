import 'package:geolocator/geolocator.dart';

class CuaHang {
  String id;
  String ten;
  String diaChi;
  double latitude;
  double longitude;
  String? thumbnailUrl;

  CuaHang(
    this.id,
    this.ten,
    this.diaChi,
    this.latitude,
    this.longitude, {
    this.thumbnailUrl,
  });

  factory CuaHang.fromMap(Map<String, dynamic> map) {
    return CuaHang(
      map['id'] ?? '',
      map['ten'] ?? '',
      map['diaChi'] ?? '',
      (map['latitude'] as num? ?? 0).toDouble(),
      (map['longitude'] as num? ?? 0).toDouble(),
      thumbnailUrl: map['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ten': ten,
      'diaChi': diaChi,
      'latitude': latitude,
      'longitude': longitude,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  /// Trả về khoảng cách (mét) đến vị trí lat/lon
  double distanceTo(double lat, double lon) {
    return Geolocator.distanceBetween(
      latitude,
      longitude,
      lat,
      lon,
    );
  }
}