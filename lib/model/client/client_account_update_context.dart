import 'client_sex.dart';
import 'client_agreements.dart';

/// The `ClientAccountUpdateContext` class represents the context for updating a client's account
/// information, including personal details, agreements, and custom attributes.
class ClientAccountUpdateContext {
  String? email;
  String? customId;
  String? uuid;
  String? firstName;
  String? lastName;
  ClientSex? sex;
  String? phone;
  String? company;
  String? address;
  String? province;
  String? city;
  String? zipcode;
  String? countrycode;
  ClientAgreements? agreements;
  Map<String, Object>? attributes;

  ClientAccountUpdateContext(
      {this.email,
      this.customId,
      this.uuid,
      this.firstName,
      this.lastName,
      this.sex,
      this.phone,
      this.company,
      this.address,
      this.province,
      this.city,
      this.zipcode,
      this.countrycode,
      this.agreements,
      this.attributes});

  /// `Map asMap()` is a method that returns a `Map` object containing all the properties of the
  /// `ClientAccountUpdateContext` instance. The keys of the map correspond to the property names, and
  /// the values correspond to the property values.
  Map asMap() => {
        'email': email,
        'customId': customId,
        'uuid': uuid,
        'firstName': firstName,
        'lastName': lastName,
        'sex': sex?.getSexAsString(),
        'phone': phone,
        'company': company,
        'address': address,
        'province': province,
        'city': city,
        'zipcode': zipcode,
        'countrycode': countrycode,
        'agreements': agreements?.asMap(),
        'attributes': attributes
      };
}
