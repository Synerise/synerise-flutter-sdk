import 'dart:collection';

class Attributes {
  HashMap<dynamic, dynamic>? properties = HashMap();
  Attributes(HashMap<dynamic, dynamic>? properties);

  Attributes add(String key, String value) {
    properties![key] = value;
    return this;
  }

  HashMap<dynamic, dynamic>? getProperties() {
    return properties;
  }
}
