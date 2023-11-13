import '../base/base_module_method_channel.dart';

class SettingsMethods extends BaseMethodChannel {
  Future<Map<String, dynamic>> getAllSettings() async {
    final result = await methodChannel.invokeMethod("Settings/getAllSettings");
    Map<String, dynamic> data = Map<String, dynamic>.from(result);
    return data;
  }

  Future<void> setOne(String key, dynamic value) async {
    await methodChannel
        .invokeMethod("Settings/setOne", {'key': key, 'value': value});
  }

  Future<void> setMany(Map<String, dynamic> settings) async {
    await methodChannel.invokeMethod("Settings/setMany", settings);
  }
}
