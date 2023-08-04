import 'client_agreements.dart';

/// The `ClientCondtitionalAuthContext` class represents the authentication context of a client, including their ID,
/// agreements, and attributes.
class ClientCondtitionalAuthContext {
  ClientAgreements? agreements;
  Map<String, Object>? attributes;

  ClientCondtitionalAuthContext({this.agreements, this.attributes});

  /// `ClientCondtitionalAuthContext.fromMap(Map map)` is a constructor that takes a `Map` as an argument and
  /// creates a new instance of `ClientCondtitionalAuthContext` using the values from the `Map`.
  ClientCondtitionalAuthContext.fromMap(Map map)
      : this(
            agreements: map['agreements'] != null ? ClientAgreements.fromMap(map['agreements']) : null,
            attributes: map['attributes'] != null ? Map<String, Object>.from(map['attributes']) : null);

  Map asMap() => {'agreements': agreements?.asMap(), 'attributes': attributes};
}
