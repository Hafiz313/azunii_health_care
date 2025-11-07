import 'package:get_storage/get_storage.dart';

class StorageService {
  // Singleton pattern to ensure a single instance of the class
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final GetStorage _storage = GetStorage();
  Future<void> saveData(String key, dynamic value) async {
    if (value is String) {
      await _storage.write(key, value);
    } else if (value is int) {
      await _storage.write(key, value);
    } else if (value is bool) {
      await _storage.write(key, value);
    } else if (value is double) {
      await _storage.write(key, value);
    } else if (value is List<String>) {
      await _storage.write(key, value);
    } else {
      throw ArgumentError("Unsupported data type");
    }
  }

  dynamic getData(String key, {dynamic defaultValue}) {
    var value = _storage.read(key);
    return value ?? defaultValue;
  }

  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  bool containsKey(String key) {
    return _storage.hasData(key);
  }
}
