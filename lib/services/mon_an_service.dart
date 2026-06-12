import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/mon_an.dart';
import 'base_service.dart';

class MonAnService extends BaseService<MonAn> {
  final CollectionReference monAnCollection =
      FirebaseFirestore.instance.collection('mon_an');

  @override
  Future<void> saveData(MonAn item) async {
    try {
      await monAnCollection.doc(item.id).set(item.toMap());
    } catch (e) {
      throw Exception('Lỗi khi lưu món ăn: $e');
    }
  }

  @override
  Future<List<MonAn>> getAll() async {
    final snapshot = await monAnCollection.get();
    return snapshot.docs
        .map((doc) => MonAn.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<MonAn>> getByCategory(String category) async {
    final snapshot =
        await monAnCollection.where('category', isEqualTo: category).get();
    return snapshot.docs
        .map((doc) => MonAn.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MonAn?> getById(String id) async {
    final doc = await monAnCollection.doc(id).get();
    if (!doc.exists) return null;
    return MonAn.fromMap(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> updateData(String id, MonAn item) async {
    try {
      await monAnCollection.doc(id).update(item.toMap());
    } catch (e) {
      throw Exception('Lỗi khi update món ăn: $e');
    }
  }

  @override
  Future<void> deleteData(String id) async {
    try {
      await monAnCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa món ăn: $e');
    }
  }

  /// Stream realtime
  @override
  Stream<List<MonAn>> getStream({String? category}) {
    Query query = monAnCollection;
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => MonAn.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
}