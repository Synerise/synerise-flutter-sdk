import '../../enums/client/client_sex.dart';
import 'package:synerise_flutter_sdk/model/client/client_agreements.dart';

class ClientAccountInformation {
  final int clientId;
  final String email;
  final String? phone;
  final String? customId;
  final String uuid;

  final String? firstName;
  final String? lastName;
  final String? displayName;
  final ClientSex sex;
  final String? birthDate;
  final String? avatarUrl;

  final String? company;
  final String? address;
  final String? city;
  final String? province;
  final String? zipCode;
  final String? countryCode;

  final bool? anonymous;
  final DateTime? lastActivityDate;

  final ClientAgreements? agreements;

  final Object? attributes;
  final List<String?> tags;

  ClientAccountInformation(
      {required this.clientId,
      required this.email,
      this.phone,
      this.customId,
      required this.uuid,
      this.firstName,
      this.lastName,
      this.displayName,
      required this.sex,
      this.birthDate,
      this.avatarUrl,
      this.company,
      this.address,
      this.province,
      this.city,
      this.zipCode,
      this.countryCode,
      this.anonymous,
      this.lastActivityDate,
      this.agreements,
      this.attributes,
      required this.tags});

  ClientAccountInformation.fromMap(Map map)
      : this(
            clientId: map['clientId'],
            email: map['email'],
            phone: map['phone'],
            customId: map['customId'],
            uuid: map['uuid'],
            firstName: map['firstName'],
            lastName: map['lastName'],
            displayName: map['displayName'],
            sex: ClientSex.getClientSexFromString(map['sex']),
            birthDate: map['birthDate'],
            avatarUrl: map['avatarUrl'],
            company: map['company'],
            address: map['address'],
            province: map['province'],
            city: map['city'],
            zipCode: map['zipCode'],
            countryCode: map['countryCode'],
            anonymous: map['anonymous'],
            lastActivityDate: map['lastActivityDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastActivityDate']) : null,
            agreements: ClientAgreements.fromMap(map['agreements']),
            attributes: map['attributes'],
            tags: List<String>.from(map['tags']));
}
