abstract class BaseLocalDataSource<TableType, ModelType> {
  BaseLocalDataSource();

  void _init() {}

  Future<List<ModelType>> getFormattedData();

  Future<void> insertOrUpdateAll(List<ModelType> todos);
/*
  Future<TableType> getByID(int id) async {
    var isar = IsarUtil().isar;

    final shoes = await isar.
        .where()
        .sizeBetween(42, 46)
        .filter()
        .modelContains('nike', caseSensitive: false)
        .not()
        .modelContains('adidas', caseSensitive: false)
        .sortByModelDesc()
        .offset(10)
        .limit(10)
        .findAll();
  }

  Future<TableType> getLazy({required TableType defaultValue}) async {
    final Box<TableType> box = await _openBox();
    return box.get(key) ?? defaultValue;
  }

  Future<List<TableType>> getAll() async {
    final Box<TableType> box = await _openBox();
    return box.toMap().values.toList();
  }

  Future<void> put(String key, TableType value) async {
    final Box<TableType> box = await _openBox();
    await box.put(key, value);
  }

  Future<void> putAll(Map<String, TableType> items) async {
    final Box<TableType> box = await _openBox();
    await box.putAll(items);
  }

  Future<void> delete(String key) async {
    final Box<TableType> box = await _openBox();
    await box.delete(key);
  }

  Future<void> deleteAll() async {
    final Box<TableType> box = await _openBox();
    final List<String> boxKeys = await keys;
    await box.deleteAll(boxKeys);
  }

  Future<List<String>> get keys async {
    final Box<TableType> box = await _openBox();
    final List<String> result = box.keys.map((k) => k.toString()).toList();
    return result;
  }*/
}
