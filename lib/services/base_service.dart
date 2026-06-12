abstract class BaseService<T> {
  /// CREATE
  Future<void> saveData(T item);

  /// READ ALL
  Future<List<T>> getAll();

  /// READ BY ID
  Future<T?> getById(String id);

  /// UPDATE
  Future<void> updateData(String id, T item);

  /// DELETE
  Future<void> deleteData(String id);

  /// Optional: stream realtime
  Stream<List<T>> getStream() {
    throw UnimplementedError('getStream() not implemented');
  }
}