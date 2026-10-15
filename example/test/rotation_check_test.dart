import 'package:flutter_test/flutter_test.dart';

import 'package:synerise_flutter_sdk_example/views/injector/overlay/overlay_sample_support.dart';

void main() {
  group('RotationCheck (inline)', () {
    test('waits for the campaign before asking for a rotation', () {
      final RotationCheck check = RotationCheck(RotationCheckKind.inline);
      expect(check.recordOrientation('portrait'), isTrue);
      expect(check.rotationCount, 1);
      expect(check.verdict, 'rotation check: waiting for the campaign to load');
    });

    test('asks for a rotation once loaded and nothing rotated yet', () {
      final RotationCheck check = RotationCheck(RotationCheckKind.inline);
      check.recordOrientation('portrait');
      check.recordPrimary();
      expect(check.verdict, 'rotation check: now rotate the device');
    });

    test('ignores a repeated orientation report', () {
      final RotationCheck check = RotationCheck(RotationCheckKind.inline);
      check.recordOrientation('portrait');
      expect(check.recordOrientation('portrait'), isFalse);
      expect(check.rotationCount, 1);
    });

    test('passes when no callback fired after the rotation', () {
      final RotationCheck check = RotationCheck(RotationCheckKind.inline);
      check.recordOrientation('portrait');
      check.recordPrimary();
      check.recordOrientation('landscape');
      expect(check.rotationCount, 2);
      expect(check.verdict, 'rotation check: PASS — survived rotation, no re-render, no failure');
    });

    test('fails and counts the callbacks fired after the rotation', () {
      final RotationCheck check = RotationCheck(RotationCheckKind.inline);
      check.recordOrientation('portrait');
      check.recordPrimary();
      check.recordOrientation('landscape');
      check.recordPrimary();
      check.recordSecondary();
      expect(check.verdict, 'rotation check: FAIL — rotation caused onLoaded +1, onFailed +1');
    });
  });

  group('RotationCheck (overlay)', () {
    test('asks to trigger first', () {
      final RotationCheck check = RotationCheck(RotationCheckKind.overlay);
      check.recordOrientation('portrait');
      expect(check.verdict, 'rotation check: trigger the overlay, then rotate');
    });

    test('uses overlay wording for PASS and FAIL', () {
      final RotationCheck check = RotationCheck(RotationCheckKind.overlay);
      check.recordOrientation('portrait');
      check.recordPrimary();
      check.recordOrientation('landscape');
      expect(check.verdict, 'rotation check: PASS — survived rotation, no re-present, no discard');
      check.recordSecondary();
      expect(check.verdict, 'rotation check: FAIL — rotation caused onPresent +0, onHide +1');
    });
  });
}
