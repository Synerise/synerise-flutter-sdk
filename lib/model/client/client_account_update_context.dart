import '../../enums/client/client_sex.dart';
import 'client_agreements.dart';

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
