/// `SyneriseSource`represents the possible source of Synerise activities. It has several possible
/// values such as 'SIMPLE_PUSH', 'BANNER', 'WALKTHROUGH', etc.
enum SyneriseSource {
  notSpecified('NOT_SPECIFIED'),
  simplePush('SIMPLE_PUSH'),
  banner('BANNER'),
  walkthrough('WALKTHROUGH'),
  inAppMessage('IN_APP_MESSAGE');

  const SyneriseSource(this.syneriseSource);

  final String syneriseSource;

  /// The `fromString` method is a static method of the `SyneriseSource` enum. It takes a `String`
  /// parameter called `string` and returns a `SyneriseSource` value based on the input string.
  static SyneriseSource fromString(String string) {
    if (string == 'SIMPLE_PUSH') {
      return SyneriseSource.simplePush;
    } else if (string == 'BANNER') {
      return SyneriseSource.banner;
    } else if (string == 'WALKTHROUGH') {
      return SyneriseSource.walkthrough;
    } else if (string == 'IN_APP_MESSAGE') {
      return SyneriseSource.inAppMessage;
    } else {
      return SyneriseSource.notSpecified;
    }
  }
}
