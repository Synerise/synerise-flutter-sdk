import '../../enums/client/client_sex.dart';
import 'client_agreements.dart';

/// The `ClientSimpleAuthenticationData` class is a data model that represents the simple authentication data
/// of a client. It contains various properties such as email, phone number, custom ID, UUID, first
/// name, last name, display name, sex, birth date, avatar URL, company, address, city, province, zip
/// code, country code, agreements, and attributes.
class ClientSimpleAuthenticationData {
  String? email;
  String? phone;
  String? customId;
  String? uuid;

  String? firstName;
  String? lastName;
  String? displayName;
  ClientSex? sex;
  String? birthDate;
  String? avatarUrl;

  String? company;
  String? address;
  String? city;
  String? province;
  String? zipCode;
  String? countryCode;

  ClientAgreements? agreements;

  Map<String, Object>? attributes;

  ClientSimpleAuthenticationData({
    this.email,
    this.phone,
    this.customId,
    this.uuid,
    this.firstName,
    this.lastName,
    this.displayName,
    this.sex,
    this.birthDate,
    this.avatarUrl,
    this.company,
    this.address,
    this.city,
    this.province,
    this.zipCode,
    this.countryCode,
    this.agreements,
    this.attributes,
  });

  /// The `asMap()` method in the `ClientSimpleAuthenticationData` class is used to convert the object
  /// into a `Map` representation. It returns a `Map` object that contains all the properties of the
  /// `ClientSimpleAuthenticationData` object. Each property is mapped to its corresponding key-value
  /// pair in the `Map`.
  Map asMap() => {
        'email': email,
        'phone': phone,
        'customId': customId,
        'uuid': uuid,
        'firstName': firstName,
        'lastName': lastName,
        'displayName': displayName,
        'sex': sex?.getSexAsString(),
        'birthDate': birthDate,
        'avatarUrl': avatarUrl,
        'company': company,
        'address': address,
        'city': city,
        'province': province,
        'zipCode': zipCode,
        'countryCode': countryCode,
        'agreements': agreements?.asMap(),
        'attributes': attributes
      };
}
