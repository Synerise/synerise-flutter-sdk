import 'client_sex.dart';
import '../../utils/synerise_utils.dart';
import 'client_agreements.dart';

/// The class represents client account information with various properties such as email, phone, name,
/// address, and agreements.
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

  final Map<String, Object>? attributes;
  final List<String?>? tags;

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
      this.tags});

  /// This is a named constructor in the `ClientAccountInformation` class that takes a `Map` as input
  /// and creates a new instance of `ClientAccountInformation` with the values extracted from the map.
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
            lastActivityDate: map['lastActivityDate'] != null
                ? SyneriseUtils.formatIntToDateTime(map['lastActivityDate'])
                : null,
            agreements: map['agreements'] != null
                ? ClientAgreements.fromMap(map['agreements'])
                : null,
            attributes: map['attributes'] != null
                ? Map<String, Object>.from(map['attributes'])
                : null,
            tags: List<String>.from(map['tags']));
}
