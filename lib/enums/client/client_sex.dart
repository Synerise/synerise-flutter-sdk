/// This is defining an enumeration type called `ClientSex` with four possible values: `notSpecified`,
/// `male`, `female`, and `other`. Each value is assigned a string representation that corresponds to
/// the value's name in all caps.
enum ClientSex {
  notSpecified('NOT_SPECIFIED'),
  male('MALE'),
  female('FEMALE'),
  other('OTHER');

  const ClientSex(this.clientSex);

  final String clientSex;

  /// The function returns the client's sex as a string.
  String getSexAsString() {
    return clientSex;
  }

  /// This function returns a ClientSex enum value based on a given string input.
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
