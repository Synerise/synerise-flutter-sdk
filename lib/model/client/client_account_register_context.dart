import '../../enums/client/client_sex.dart';
import 'client_agreements.dart';

/// The `ClientAccountRegisterContext` class represents the context for registering a client account,
/// including personal information, agreements, and attributes.
class ClientAccountRegisterContext {
  String email;
  String password;
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

  ClientAccountRegisterContext(
      {required this.email,
      required this.password,
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

  /// `ClientAccountRegisterContext.fromMap(Map map)` is a constructor that takes a `Map` as an argument
  /// and creates a new instance of `ClientAccountRegisterContext` using the values from the `Map`.
  ClientAccountRegisterContext.fromMap(Map map)
      : this(
          email: map['email'],
          password: map['password'],
          firstName: map['firstName'],
          lastName: map['lastName'],
          sex: map['sex'] != null
              ? ClientSex.getClientSexFromString(map['sex'])
              : null,
          phone: map['phone'],
          company: map['company'],
          address: map['address'],
          city: map['city'],
          zipcode: map['zipcode'],
          countrycode: map['countrycode'],
          province: map['province'],
          uuid: map['uuid'],
          customId: map['customId'],
          agreements: map['agreements'] != null
              ? ClientAgreements.fromMap(map['agreements'])
              : null,
          attributes: map['attributes'] != null
              ? Map<String, Object>.from(map['attributes'])
              : null,
        );

  /// `Map asMap()` is a method that returns a `Map` representation of the
  /// `ClientAccountRegisterContext` object. It includes all the properties of the object as key-value
  /// pairs in the returned `Map`. If a property is null, it will not be included in the returned `Map`.
  /// The `agreements` property is converted to a `Map` using its own `asMap()` method, and the
  /// `attributes` property is included as is.
  Map asMap() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'sex': sex,
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
