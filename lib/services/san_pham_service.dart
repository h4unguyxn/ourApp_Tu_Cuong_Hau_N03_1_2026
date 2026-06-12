import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/san_pham.dart';

class SanPhamService {
  final CollectionReference monAnCollection =
      FirebaseFirestore.instance.collection('mon_an');
  final CollectionReference doUongCollection =
      FirebaseFirestore.instance.collection('do_uong');
  final CollectionReference kemCollection =
    FirebaseFirestore.instance.collection('kem');

  Future<List<SanPham>> getAllSanPham() async {
    final monAnSnapshot = await monAnCollection.get();
    final doUongSnapshot = await doUongCollection.get();
    final kemSnapshot = await kemCollection.get();

    final monAnList = monAnSnapshot.docs
        .map((doc) => SanPham.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    final doUongList = doUongSnapshot.docs
        .map((doc) => SanPham.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    final kemList = kemSnapshot.docs
      .map((doc) => SanPham.fromMap(doc.data() as Map<String, dynamic>))
      .toList();

    return [...monAnList, ...doUongList, ...kemList];
  }

  Future<List<SanPham>> getSanPhamByCuaHangId(String cuaHangId) async {
    final all = await getAllSanPham();
    return all.where((e) => e.cuaHangId == cuaHangId).toList();
  }

  Stream<List<SanPham>> getSanPhamStream({String? category}) {
    return monAnCollection.snapshots().asyncMap((monAnSnapshot) async {
      final doUongSnapshot = await doUongCollection.get();
      final kemSnapshot = await kemCollection.get();
      final monAnList = monAnSnapshot.docs
          .map((doc) => SanPham.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      final doUongList = doUongSnapshot.docs
          .map((doc) => SanPham.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      final kemList = kemSnapshot.docs
        .map((doc) => SanPham.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
      final allList = [...monAnList, ...doUongList, ...kemList];

      if (category == null || category.isEmpty) return allList;
      return allList.where((e) => e.category == category).toList();
    });
  }
}