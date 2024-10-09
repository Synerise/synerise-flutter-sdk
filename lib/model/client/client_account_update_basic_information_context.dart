import 'client_sex.dart';
import 'client_agreements.dart';

/// The `ClientAccountUpdateBasicInformationContext` class represents the context for updating a client's account
/// basic information, including personal details, agreements, and custom attributes.
class ClientAccountUpdateBasicInformationContext {
  String? firstName;
  String? lastName;
  String? displayName;
  ClientSex? sex;
  String? phone;
  String? company;
  String? address;
  String? province;
  String? city;
  String? zipcode;
  String? countrycode;
  String? birthDate;
  String? avatarUrl;

  ClientAgreements? agreements;
  Map<String, Object>? attributes;

  ClientAccountUpdateBasicInformationContext(
      {
        this.firstName,
        this.lastName,
        this.displayName,
        this.sex,
        this.phone,
        this.company,
        this.address,
        this.province,
        this.city,
        this.zipcode,
        this.countrycode,
        this.birthDate,
        this.avatarUrl,
        this.agreements,
        this.attributes});

  /// `Map asMap()` is a method that returns a `Map` object containing all the properties of the
  /// `ClientAccountUpdateBasicInformationContext` instance. The keys of the map correspond to the property names, and
  /// the values correspond to the property values.
  Map asMap() => {
    'firstName': firstName,
    'lastName': lastName,
    'displayName': displayName,
    'sex': sex?.getSexAsString(),
    'phone': phone,
    'company': company,
    'address': address,
    'province': province,
    'city': city,
    'zipcode': zipcode,
    'countrycode': countrycode,
    'birthDate': birthDate,
    'avatarUrl': avatarUrl,
    'agreements': agreements?.asMap(),
    'attributes': attributes
  };
}
