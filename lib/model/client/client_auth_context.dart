import 'package:synerise_flutter_sdk/model/client/client_agreements.dart';
import 'package:synerise_flutter_sdk/model/client/client_attributes.dart';

class ClientAuthContext {
  String? authId;
  ClientAgreements? agreements;
  ClientAttributes? attributes;

  ClientAuthContext({this.authId, this.agreements, this.attributes});

  String? get getAuthID => authId;
  ClientAgreements? get getAgreements => agreements;
  ClientAttributes? get getAttributes => attributes;

  // ignore: unnecessary_this
  set setAuthID(String? authID) => this.authId = authID;
  set setAgreements(ClientAgreements? agreements) => this.agreements = agreements;
  set setAttributes(ClientAttributes? attributes) => this.attributes = attributes;

  ClientAuthContext.fromMap(Map map) : this(authId: map['authID'], agreements: map['agreements'], attributes: map['attributes']);

  Map asMap() => {'authID': authId, 'agreements': agreements?.asMap(), 'attributes': attributes?.getProperties()};
}
