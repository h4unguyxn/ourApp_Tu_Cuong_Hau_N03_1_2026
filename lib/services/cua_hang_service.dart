import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/cua_hang.dart';

class CuaHangService {
  final CollectionReference cuaHangCollection =
      FirebaseFirestore.instance.collection('cua_hang');

  Future<List<CuaHang>> getAll() async {
    final snapshot = await cuaHangCollection.get();
    return snapshot.docs
        .map((doc) => CuaHang.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<CuaHang>> getNearbyStores(
      double lat, double lon, double radiusInMeters) async {
    final all = await getAll();
    final nearby = all.where((store) => store.distanceTo(lat, lon) <= radiusInMeters).toList();
    nearby.shuffle(); // random
    return nearby;
  }

  // Thêm phương thức lọc cửa hàng theo category
  Future<List<CuaHang>> getStoresByCategory(String category) async {
    // Lấy tất cả món ăn trong category
    final snapshot = await FirebaseFirestore.instance
        .collection('san_pham')
        .where('category', isEqualTo: category)
        .get();

    final storeIds = snapshot.docs.map((doc) => doc['cuaHangId'] as String).toSet();

    final allStores = await getAll();
    return allStores.where((store) => storeIds.contains(store.id)).toList();
  }
}