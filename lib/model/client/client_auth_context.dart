import 'client_agreements.dart';

/// The `ClientAuthContext` class represents the authentication context of a client, including their ID,
/// agreements, and attributes.
class ClientAuthContext {
  String? authId;
  ClientAgreements? agreements;
  Map<String, Object>? attributes;

  ClientAuthContext({this.authId, this.agreements, this.attributes});

  /// `ClientAuthContext.fromMap(Map map)` is a constructor that takes a `Map` as an argument and
  /// creates a new instance of `ClientAuthContext` using the values from the `Map`.
  ClientAuthContext.fromMap(Map map)
      : this(
            authId: map['authID'],
            agreements: map['agreements'] != null
                ? ClientAgreements.fromMap(map['agreements'])
                : null,
            attributes: map['attributes'] != null
                ? Map<String, Object>.from(map['attributes'])
                : null);

  Map asMap() => {
        'authID': authId,
        'agreements': agreements?.asMap(),
        'attributes': attributes
      };
}
