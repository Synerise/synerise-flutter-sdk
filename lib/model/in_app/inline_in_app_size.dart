/// The measured size of the content rendered by an inline in-app message, delivered through
/// `InlineInAppView.onSizeChanged` when the creative calls `SRInApp.setComponentSize(width, height)`.
///
/// The same measurement is exposed in three units: physical pixels ([widthPx], [heightPx]),
/// density-independent pixels ([width], [height]; dp on Android, points on iOS) and as a fraction
/// of the whole device screen ([widthScreenRatio], [heightScreenRatio], in range 0..1).
class InlineInAppSize {
  final int widthPx;
  final int heightPx;
  final double width;
  final double height;
  final double widthScreenRatio;
  final double heightScreenRatio;

  const InlineInAppSize(this.widthPx, this.heightPx, this.width, this.height,
      this.widthScreenRatio, this.heightScreenRatio);

  /// Builds the size from the native `onSizeChanged` payload; missing fields default to zero.
  InlineInAppSize.fromMap(Map map)
      : this(
            _toInt(map['widthPx']),
            _toInt(map['heightPx']),
            _toDouble(map['width']),
            _toDouble(map['height']),
            _toDouble(map['widthScreenRatio']),
            _toDouble(map['heightScreenRatio']));

  static int _toInt(Object? value) => value is num ? value.toInt() : 0;

  static double _toDouble(Object? value) => value is num ? value.toDouble() : 0.0;
}
