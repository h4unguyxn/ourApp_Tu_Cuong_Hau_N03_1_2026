import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/don_hang.dart';

class DonHangService {
  final CollectionReference donHangCollection =
      FirebaseFirestore.instance.collection('don_hang');
  final CollectionReference lichSuDonHangCollection =
      FirebaseFirestore.instance.collection('lich_su_don_hang');

  Future<void> saveData(DonHang item) async {
    await donHangCollection.doc(item.id).set(item.toMap());
  }

  Future<List<DonHang>> getAll() async {
    final snapshot = await donHangCollection.get();
    return snapshot.docs
        .map((doc) => DonHang.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> daNhanHang(DonHang donHang) async {
    final data = donHang.toMap();
    data['trangThai'] = 'da_nhan_hang';
    data['thoiGianHoanThanh'] = FieldValue.serverTimestamp();

    await lichSuDonHangCollection.doc(donHang.id).set(data);

    // Xóa đơn cũ
    final snapshot = await donHangCollection.where('id', isEqualTo: donHang.id).get();
    for (var doc in snapshot.docs) {
      await donHangCollection.doc(doc.id).delete();
    }
  }
}