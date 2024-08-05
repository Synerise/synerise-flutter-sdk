/// The `InitializationConfig` class represents the initialization configuration with
/// required clientApiKey and optional requestValidationSalt.
class InitializationConfig {
  String? requestValidationSalt;

  InitializationConfig({this.requestValidationSalt});

  /// `InitializationConfig.fromMap(Map map)` is a constructor that takes a `Map` as an argument and
  /// creates a new instance of `InitializationConfig` using the values from the `Map`.
  InitializationConfig.fromMap(Map map)
      : this(
            requestValidationSalt: map['requestValidationSalt']
        );

  Map asMap() => {
    'requestValidationSalt': requestValidationSalt
  };
}