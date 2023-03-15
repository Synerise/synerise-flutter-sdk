enum ClientSex {
  notSpecified('NOT_SPECIFIED'),
  male('MALE'),
  female('FEMALE'),
  other('OTHER');

  const ClientSex(this.clientSex);

  final String clientSex;

  String getSexAsString() {
    return clientSex;
  }
  
  static ClientSex getClientSexFromString(String string) {
    if (string == 'NOT_SPECIFIED') {
      return ClientSex.notSpecified;
    } else if (string == 'MALE') {
      return ClientSex.male;
    } else if (string == 'FEMALE') {
      return ClientSex.female;
    } else if (string == 'OTHER') {
      return ClientSex.other;
    } else {
      return ClientSex.notSpecified;
    }
  }
}
