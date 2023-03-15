import 'dart:collection';

class ClientAttributes {
  HashMap<dynamic, dynamic>? properties = HashMap();
  ClientAttributes(HashMap<dynamic, dynamic>? properties);

  ClientAttributes add(String key, String value) {
    properties![key] = value;
    return this;
  }

  HashMap<dynamic, dynamic>? getProperties() {
    return properties;
  }
}
