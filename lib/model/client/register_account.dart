class ClientAccountRegisterContext {
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? sex;
  final String? phone;
  final String? company;
  final String? address;
  final String? city;
  final String? zipcode;
  final String? countrycode;
  final String? province;
  final String? uuid;
  final String? customId;

  ClientAccountRegisterContext(
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
      this.customId});

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
            customId: map['customId']);

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
        'customId': customId
      };
}
