/// Well-known keys of `Synerise.injector.inAppContext`.
///
/// Use them as map keys, for example:
/// `Synerise.injector.inAppContext[InAppContextKey.jinjavaContext] = {'tier': 'gold'};`
class InAppContextKey {
  InAppContextKey._();

  /// The only part of the context sent to the backend for server-side Jinja evaluation when a
  /// campaign with a dynamic variant is rendered. It may hold a nested map; its size is validated
  /// server-side.
  static const String jinjavaContext = 'jinjavaContext';
}
