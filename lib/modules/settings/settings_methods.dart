import '../../model/base/mappings.dart';
import '../base/base_module_method_channel.dart';

class SettingsMethods extends BaseMethodChannel {
  Future<Map<String, dynamic>> getAllSettings() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<Map<String, dynamic>>("Settings/getAllSettings",
            isMappable: true, genericTypeKey: GenericTypeKey.mapStringDynamic);
  }

  Future<void> setOne(String key, dynamic value) async {
    return await SyneriseInvocation(methodChannel).invokeSDKMethod<void>(
        "Settings/setOne",
        parameters: {'key': key, 'value': value});
  }

  Future<void> setMany(Map<String, dynamic> settings) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>("Settings/setMany", parameters: settings);
  }
}
