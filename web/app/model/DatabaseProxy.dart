import 'package:framework/framework.dart';
import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';

class DatabaseProxy extends Proxy {
  static const String NAME = "DatabaseProxy";

  static const String IDB_STORE_COUNTER = "idb_counter_store";
  static const String IDB_INDEX_ID = "idb_index_id";

  late Map<String, Map<int, Map<String, Object>>> _database;
  late Database _idb;

  DatabaseProxy() : super(NAME) {
    print(">\t DatabaseProxy -> instance created");
  }

  @override
  void onRegister() {
    print(">\t DatabaseProxy -> onRegister");
  }

  @override
  void onRemove() {}

  void createDatabase(Type type) {
    String storeName = type.toString();
    print(">\t DatabaseProxy -> createDatabase > storeName: " + storeName);
    var objectStore = _idb.createObjectStore(storeName, autoIncrement: true);
    objectStore.createIndex(IDB_INDEX_ID, 'id', unique: true);
  }

  void deleteDatabase(Type type) {
    String storeName = type.toString();
    _idb.deleteObjectStore(storeName);
    print(">\t DatabaseProxy -> deleteDatabase > storeName: " + storeName);
    _database.remove(storeName);
  }

  Future<Map?> retrieveVO(Type type) async {
    String storeName = type.toString();
    Map? value;
    // read some data
    print(">\t DatabaseProxy -> retrieveVO > storeName: " + storeName);
    final txn = _idb.transaction(storeName, "readonly");
    final store = txn.objectStore(storeName);
    final cursor = store.openCursor();
    final isEmpty = await cursor.isEmpty;
    if (!isEmpty) {
      final cursorValue = await store.openCursor().first;
      print(">\t DatabaseProxy -> retrieveVO > cursorValue.value: " + cursorValue.value.toString());
      print(">\t DatabaseProxy -> retrieveVO > cursorValue.key: " + cursorValue.toString());
      await txn.completed;
      value = cursorValue.value as Map;
      value.addAll({"key": cursorValue.key});
      print(">\t DatabaseProxy -> retrieveVO > value: " + value.toString());
    }
    return value;
  }

  Future<List> retrieve(Type type, {int limit = -1}) async {
    String storeName = type.toString();
    final List<Map> results = [];
    print(">\t DatabaseProxy -> retrieve > storeName: " + storeName);
    final txn = _idb.transaction(storeName, "readonly");
    final store = txn.objectStore(storeName);
    final cursor = store.openCursor();
    await cursor.forEach((cv) {
      final value = cv.value as Map;
      value["key"] = cv.key;
      results.add(value);
      cv.next();
    });
    await txn.completed;
    // print(">\t DatabaseProxy -> retrieve > values: " + results.toString());
    return results;
  }

  Future<void> deleteItemByKey(Type type, key) async {
    String storeName = type.toString();
    print(">\t DatabaseProxy -> deleteAtIndex > storeName: " + storeName);
    print(">\t DatabaseProxy -> deleteAtIndex > key: ${key}");
    final txn = _idb.transaction(storeName, "readwrite");
    final store = txn.objectStore(storeName);
    await store.delete(key);
    await txn.completed;
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<int> insertVO(Type type, Map<String, Object> params, {int? key}) async {
    String storeName = type.toString();
    print(">\t DatabaseProxy -> insertVO > storeName: " + storeName);
    print(">\t DatabaseProxy -> insertVO > params: " + params.toString());
    // put some data
    final txn = _idb.transaction(storeName, "readwrite");
    final store = txn.objectStore(storeName);
    final result = await store.add(params, key) as int;
    print(">\t DatabaseProxy -> insertVO > result: " + result.toString());
    await txn.completed;
    return result;
  }

  Future<void> updateVO(Type type, int key, {required Map params}) async {
    String storeName = type.toString();
    print(">\t DatabaseProxy -> updateVO > storeName: " + storeName);
    final txn = _idb.transaction(storeName, "readwrite");
    final store = txn.objectStore(storeName);
    final cursor = await store.openCursor();
    final cursorValue = await cursor.firstWhere((CursorWithValue cv) {
      return cv.key == key;
    });
    if (cursorValue != null) await cursorValue.update(params);
    // final value = await store.getObject(key);
    await txn.completed;
  }

  Future<void> init(List<Type> stores) async {
    _database = Map();
    _idb = await _open(stores);
  }

  Future _open(List<Type> stores) {
    final idbFactory = getIdbFactory() as IdbFactory;
    return idbFactory.open('applicationIDB', version: 1, onUpgradeNeeded: (VersionChangeEvent e) {
      Database db = e.database;
      stores.forEach((storeType) {
        String storeName = storeType.toString();
        var objectStore = db.createObjectStore(storeName, autoIncrement: true);
        objectStore.createIndex(IDB_INDEX_ID, 'id', unique: true);
      });
    });
  }
}
