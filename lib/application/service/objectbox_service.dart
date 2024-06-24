import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

class ObjectboxService<T> {
  final Box<T> _box;

  ObjectboxService(Store store, Type type) : _box = store.box<T>();

  int add(T entity) {
    return _box.put(entity);
  }

  T? getById(int id) {
    return _box.get(id);
  }

  List<T> getAll() {
    return _box.getAll();
  }

  // Update
  void put(T entity) {
    _box.put(entity);
  }

  void putMany(List<T> entity) {
    _box.putMany(entity);
  }

  bool delete(int id) {
    return _box.remove(id);
  }

  void deleteMany(List<int> ids) {
    _box.removeMany(ids);
  }

  void deleteAll() {
    _box.removeAll();
  }
}
