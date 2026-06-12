import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/do_uong.dart';
import 'base_service.dart';

class DoUongService extends BaseService<DoUong> {
  final CollectionReference doUongCollection =
      FirebaseFirestore.instance.collection('do_uong');

  @override
  Future<void> saveData(DoUong item) async {
    try {
      await doUongCollection.doc(item.id).set(item.toMap());
    } catch (e) {
      throw Exception('Lỗi khi lưu đồ uống: $e');
    }
  }

  @override
  Future<List<DoUong>> getAll() async {
    final snapshot = await doUongCollection.get();
    return snapshot.docs
        .map((doc) => DoUong.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<DoUong?> getById(String id) async {
    final doc = await doUongCollection.doc(id).get();
    if (!doc.exists) return null;
    return DoUong.fromMap(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> updateData(String id, DoUong item) async {
    final doc = doUongCollection.doc(id);
    try {
      await doc.update(item.toMap());
    } catch (e) {
      throw Exception('Lỗi khi update đồ uống: $e');
    }
  }

  @override
  Future<void> deleteData(String id) async {
    final doc = doUongCollection.doc(id);
    try {
      await doc.delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa đồ uống: $e');
    }
  }

  /// Stream realtime
  @override
  Stream<List<DoUong>> getStream({String? category}) {
    Query query = doUongCollection;
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => DoUong.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
}