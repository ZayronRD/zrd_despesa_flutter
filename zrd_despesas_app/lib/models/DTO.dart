// ignore: file_names
abstract class DTO<T> {
  Future<List<T>> get();
  // Future<T?> getById(int id);
  Future<void> insert(T item, {Object? extra});
  // Future<void> update(T item);
  Future<void> delete(String id);
}
