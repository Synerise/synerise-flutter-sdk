import '../../enums/client/client_sex.dart';
import 'package:synerise_flutter_sdk/model/client/client_agreements.dart';

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
  Object? attributes;

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

  ClientAccountRegisterContext.fromMap(Map map)
      : this(
            email: map['email'],
            password: map['password'],
            firstName: map['firstName'],
            lastName: map['lastName'],
            sex: map['sex'],
            phone: map['phone'],
            company: map['company'],
            address: map['address'],
            city: map['city'],
            zipcode: map['zipcode'],
            countrycode: map['countrycode'],
            province: map['province'],
            uuid: map['uuid'],
            customId: map['customId'],
            agreements: map['agreements'],
            attributes: map['attributes']);

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
