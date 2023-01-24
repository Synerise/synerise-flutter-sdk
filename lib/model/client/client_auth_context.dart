import 'package:synerise_flutter_sdk/model/client/agreements.dart';
import 'package:synerise_flutter_sdk/model/client/attributes.dart';

class ClientAuthContext {
  String? authID;
  Agreements? agreements;
  Attributes? attributes;

  ClientAuthContext({this.authID, this.agreements, this.attributes});

  String? get getAuthID => authID;
  Agreements? get getAgreements => agreements;
  Attributes? get getAttributes => attributes;

  set setAuthID(String? authID) => this.authID = authID;
  set setAgreements(Agreements? agreements) => this.agreements = agreements;
  set setAttributes(Attributes? attributes) => this.attributes = attributes;

  ClientAuthContext.fromMap(Map map) : this(authID: map['authID'], agreements: map['agreements'], attributes: map['attributes']);

  Map asMap() => {'authID': authID, 'agreements': agreements?.asMap(), 'attributes': attributes?.getProperties()};
}
