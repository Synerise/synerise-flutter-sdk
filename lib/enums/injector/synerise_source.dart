/// `SyneriseSource`represents the possible source of Synerise activities. It has several possible
/// values such as 'SIMPLE_PUSH', 'IN_APP_MESSAGE', 'INLINE_IN_APP_MESSAGE', etc.
enum SyneriseSource {
  notSpecified('NOT_SPECIFIED'),
  simplePush('SIMPLE_PUSH'),
  inAppMessage('IN_APP_MESSAGE'),
  inlineInAppMessage('INLINE_IN_APP_MESSAGE');

  const SyneriseSource(this.syneriseSource);

  final String syneriseSource;

  /// The `fromString` method is a static method of the `SyneriseSource` enum. It takes a `String`
  /// parameter called `string` and returns a `SyneriseSource` value based on the input string.
  static SyneriseSource fromString(String string) {
    if (string == 'SIMPLE_PUSH') {
      return SyneriseSource.simplePush;
    } else if (string == 'IN_APP_MESSAGE') {
      return SyneriseSource.inAppMessage;
    } else if (string == 'INLINE_IN_APP_MESSAGE') {
      return SyneriseSource.inlineInAppMessage;
    } else {
      return SyneriseSource.notSpecified;
    }
  }
}
