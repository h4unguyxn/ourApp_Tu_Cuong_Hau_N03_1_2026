import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService extends ChangeNotifier {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  double? latitude;
  double? longitude;
  String addressText = "Chọn vị trí";

  bool get hasLocation => latitude != null && longitude != null;

  Future<bool> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        addressText = "GPS đang tắt";
        notifyListeners();
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        addressText = "Chưa cấp quyền vị trí";
        notifyListeners();
        return false;
      }

      // Sử dụng LocationSettings chuẩn mới
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latitude = pos.latitude;
      longitude = pos.longitude;

      final addr = await getAddressFromOpenStreetMap(latitude!, longitude!);
      if (addr != null && addr.trim().isNotEmpty) {
        addressText = addr;
      } else {
        addressText =
            "${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}";
      }
      notifyListeners();
      return true;
    } catch (e) {
      addressText = "Không lấy được vị trí";
      notifyListeners();
      return false;
    }
  }

  Future<String?> getAddressFromOpenStreetMap(double lat, double lon) async {
    try {
      final url = Uri.parse(
          "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lon&zoom=18&addressdetails=1");
      final res = await http.get(url, headers: {"User-Agent": "HCTFoodApp/1.0"});
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body);
      return data["display_name"];
    } catch (e) {
      return null;
    }
  }

  void setManualAddress(String addr) {
    addressText = addr;
    latitude = null;
    longitude = null;
    notifyListeners();
  }

  void clearLocation() {
    latitude = null;
    longitude = null;
    addressText = "Chọn vị trí";
    notifyListeners();
  }
}