import 'package:flutter_test/flutter_test.dart';

import 'package:synerise_flutter_sdk_example/views/injector/overlay/overlay_sample_support.dart';

void main() {
  group('ExpressionCheck', () {
    test('has no verdict before the expression-fail event is sent', () {
      final ExpressionCheck check = ExpressionCheck();
      check.recordPresent();
      expect(check.verdict, isNull);
    });

    test('passes when nothing presented after the send', () {
      final ExpressionCheck check = ExpressionCheck();
      check.recordPresent();
      check.recordSend();
      expect(check.presentCountAtSend, 1);
      expect(check.verdict, 'expression check: PASS — no overlay presented');
    });

    test('fails when an overlay presented after the send', () {
      final ExpressionCheck check = ExpressionCheck();
      check.recordSend();
      check.recordPresent();
      expect(check.verdict,
          'expression check: FAIL — overlay presented despite a non-matching expression');
    });
  });
}
