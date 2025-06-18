/// The `InitializationConfig` class represents the initialization configuration with
/// required clientApiKey and optional requestValidationSalt.
class InitializationConfig {
  String? requestValidationSalt;
  bool? initialDoNotTrack;

  InitializationConfig({this.requestValidationSalt, this.initialDoNotTrack});

  /// `InitializationConfig.fromMap(Map map)` is a constructor that takes a `Map` as an argument and
  /// creates a new instance of `InitializationConfig` using the values from the `Map`.
  InitializationConfig.fromMap(Map map)
      : this(
            requestValidationSalt: map['requestValidationSalt'],
            initialDoNotTrack: map['initialDoNotTrack']
        );

  Map asMap() => {
    'requestValidationSalt': requestValidationSalt,
    'initialDoNotTrack': initialDoNotTrack
  };
}