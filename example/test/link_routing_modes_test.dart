import 'package:flutter_test/flutter_test.dart';

import 'package:synerise_flutter_sdk_example/views/injector/overlay/overlay_sample_support.dart';

void main() {
  group('LinkRoutingModes', () {
    test('starts with in-app listeners claiming links and the injector logging only', () {
      final LinkRoutingModes modes = LinkRoutingModes();
      expect(modes.inAppListenerMode, InAppListenerMode.claimsLinks);
      expect(modes.injectorListenerMode, InjectorListenerMode.logsOnly);
      expect(modes.inAppListenerLabel,
          'in-app listeners CLAIM links (onOpenUrl / onDeepLink implemented)');
      expect(modes.injectorListenerLabel, 'injector LOGS ONLY — nothing opens');
      expect(modes.expectation,
          'overlay/inline listener fires · INJECTOR fires with the source · nothing opens');
    });

    test('toggles the in-app listener mode and its wording', () {
      final LinkRoutingModes modes = LinkRoutingModes();
      modes.toggleInAppListenerMode();
      expect(modes.inAppListenerMode, InAppListenerMode.claimsNothing);
      expect(modes.inAppListenerLabel, 'in-app listeners CLAIM NOTHING (link handlers omitted)');
      expect(modes.expectation,
          'overlay/inline listener SILENT · INJECTOR fires with the source · nothing opens');
      modes.toggleInAppListenerMode();
      expect(modes.inAppListenerMode, InAppListenerMode.claimsLinks);
    });

    test('toggles the injector listener mode and its wording', () {
      final LinkRoutingModes modes = LinkRoutingModes();
      modes.toggleInjectorListenerMode();
      expect(modes.injectorListenerMode, InjectorListenerMode.delegatesToSdk);
      expect(modes.injectorListenerLabel, 'injector DELEGATES to SDK — the target opens');
      expect(modes.expectation,
          'overlay/inline listener fires · INJECTOR fires with the source · target opens');
      modes.toggleInjectorListenerMode();
      expect(modes.injectorListenerMode, InjectorListenerMode.logsOnly);
    });
  });
}
