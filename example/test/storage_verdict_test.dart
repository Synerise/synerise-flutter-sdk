import 'package:flutter_test/flutter_test.dart';

import 'package:synerise_flutter_sdk_example/views/injector/overlay/overlay_sample_support.dart';

void main() {
  group('StorageVerdict', () {
    test('starts by asking to mount the reader and trigger the writer', () {
      final StorageVerdict verdict = StorageVerdict();
      expect(verdict.pollTickCount, 0);
      expect(verdict.lastPolledValue, 'never polled');
      expect(verdict.writtenLabel, 'nothing yet');
      expect(verdict.ticksDuringOverlayLabel, 'n/a');
      expect(verdict.verdict, 'storage check: mount the reader, then trigger the overlay writer');
    });

    test('counts ticks and keeps the last polled value, null shown as "null"', () {
      final StorageVerdict verdict = StorageVerdict();
      verdict.recordTick(null);
      verdict.recordTick('"abc"');
      expect(verdict.pollTickCount, 2);
      expect(verdict.lastPolledValue, '"abc"');
      verdict.recordTick(null);
      expect(verdict.lastPolledValue, 'null');
    });

    test('is inconclusive while the overlay never reported a write', () {
      final StorageVerdict verdict = StorageVerdict();
      verdict.recordOverlayPresent();
      expect(verdict.ticksDuringOverlayLabel, 'overlay still displayed');
      expect(verdict.verdict,
          'storage check: INCONCLUSIVE — the overlay never reported a completed write');
    });

    test('fails when the reader produced zero ticks under the overlay', () {
      final StorageVerdict verdict = StorageVerdict();
      verdict.recordTick(null);
      verdict.recordOverlayPresent();
      verdict.recordWriteDone('"sku-1"');
      verdict.recordOverlayHide();
      expect(verdict.pollTicksDuringOverlay, 0);
      expect(verdict.ticksDuringOverlayLabel, '0');
      expect(verdict.writtenLabel, '"sku-1"');
      expect(verdict.verdict,
          'storage check: FAIL — reader JS froze while the overlay was displayed (0 ticks)');
    });

    test('fails when the poll exhausted without seeing the write', () {
      final StorageVerdict verdict = StorageVerdict();
      verdict.recordOverlayPresent();
      verdict.recordTick(null);
      verdict.recordWriteDone('"sku-1"');
      verdict.recordOverlayHide();
      verdict.recordExhausted();
      expect(verdict.verdict,
          'storage check: FAIL — reader kept polling but never saw the overlay write');
    });

    test('waits while the reader is still polling after the write', () {
      final StorageVerdict verdict = StorageVerdict();
      verdict.recordOverlayPresent();
      verdict.recordTick(null);
      verdict.recordWriteDone('"sku-1"');
      verdict.recordOverlayHide();
      expect(verdict.verdict, 'storage check: waiting — reader still polling');
    });

    test('passes once the reader resolves the value', () {
      final StorageVerdict verdict = StorageVerdict();
      verdict.recordOverlayPresent();
      verdict.recordWriteDone('"sku-1"');
      verdict.recordResolved('"sku-1"');
      expect(verdict.verdict, 'storage check: PASS — inline read ""sku-1"" written by the overlay');
    });
  });
}
