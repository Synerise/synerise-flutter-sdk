import '../../enums/client/client_sex.dart';
import 'client_agreements.dart';

/// The `ClientAccountUpdateContext` class represents the context for updating a client's account
/// information, including personal details, agreements, and custom attributes.
class ClientAccountUpdateContext {
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  ClientSex? sex;
  String? phone;
  String? company;
  String? address;
  String? city;
  String? zipcode;
  String? countrycode;
  String? province;
  String? uuid;
  String? customId;
  ClientAgreements? agreements;
  Map<String, Object>? attributes;

  ClientAccountUpdateContext(
      {this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.sex,
      this.phone,
      this.company,
      this.address,
      this.city,
      this.zipcode,
      this.countrycode,
      this.province,
      this.uuid,
      this.customId,
      this.agreements,
      this.attributes});

  /// `Map asMap()` is a method that returns a `Map` object containing all the properties of the
  /// `ClientAccountUpdateContext` instance. The keys of the map correspond to the property names, and
  /// the values correspond to the property values.
  Map asMap() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'sex': sex?.getSexAsString(),
        'phone': phone,
        'company': company,
        'address': address,
        'city': city,
        'zipcode': zipcode,
        'countrycode': countrycode,
        'province': province,
        'uuid': uuid,
        'customId': customId,
        'agreements': agreements?.asMap(),
        'attributes': attributes
      };
}
