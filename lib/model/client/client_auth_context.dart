import 'client_agreements.dart';

class ClientAuthContext {
  String? authId;
  ClientAgreements? agreements;
  Map<String, Object>? attributes;

  ClientAuthContext({this.authId, this.agreements, this.attributes});

  ClientAuthContext.fromMap(Map map)
      : this(authId: map['authID'], agreements: map['agreements'], attributes: Map<String, Object>.from(map['attributes']));
  
  Map asMap() => {'authID': authId, 'agreements': agreements?.asMap(), 'attributes': attributes};
}
