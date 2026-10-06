import 'dart:convert';

import 'package:synerise_flutter_sdk/synerise.dart';

export '../sample_log.dart';

/// Which pair of callbacks a [RotationCheck] counts: inline `onLoaded`/`onFailed` or overlay
/// `onPresent`/`onHide`. Only the verdict wording differs.
enum RotationCheckKind { inline, overlay }

/// Rotation verdict shared by the inline and overlay Rotation screens. Mirrors the RN screens:
/// every orientation report (the first layout included) counts as a "rotation" and snapshots the
/// counters, and the verdict appears after the second report. Any callback that fires after the last
/// rotation flips the verdict to FAIL.
class RotationCheck {
  RotationCheck(this.kind);

  final RotationCheckKind kind;

  int primaryCount = 0;
  int secondaryCount = 0;
  int rotationCount = 0;
  String? lastOrientation;

  int _primaryAtLastRotation = 0;
  int _secondaryAtLastRotation = 0;

  void recordPrimary() => primaryCount++;

  void recordSecondary() => secondaryCount++;

  /// Returns `true` when [orientation] differs from the last report (or is the first one), i.e. when
  /// the screen should log an `[orientation]` line.
  bool recordOrientation(String orientation) {
    if (orientation == lastOrientation) {
      return false;
    }
    lastOrientation = orientation;
    rotationCount++;
    _primaryAtLastRotation = primaryCount;
    _secondaryAtLastRotation = secondaryCount;
    return true;
  }

  String get verdict {
    final bool inline = kind == RotationCheckKind.inline;
    if (primaryCount == 0) {
      return inline
          ? 'rotation check: waiting for the campaign to load'
          : 'rotation check: trigger the overlay, then rotate';
    }
    if (rotationCount < 2) {
      return 'rotation check: now rotate the device';
    }
    final int primaryDelta = primaryCount - _primaryAtLastRotation;
    final int secondaryDelta = secondaryCount - _secondaryAtLastRotation;
    if (primaryDelta == 0 && secondaryDelta == 0) {
      return inline
          ? 'rotation check: PASS — survived rotation, no re-render, no failure'
          : 'rotation check: PASS — survived rotation, no re-present, no discard';
    }
    return inline
        ? 'rotation check: FAIL — rotation caused onLoaded +$primaryDelta, onFailed +$secondaryDelta'
        : 'rotation check: FAIL — rotation caused onPresent +$primaryDelta, onHide +$secondaryDelta';
  }
}

/// Overlay Basic's expression verdict: an event whose campaign expression cannot match must present
/// nothing, so the check compares `onPresent` counts before and after the send.
class ExpressionCheck {
  int presentCount = 0;
  int? presentCountAtSend;

  void recordPresent() => presentCount++;

  void recordSend() => presentCountAtSend = presentCount;

  String? get verdict {
    final int? atSend = presentCountAtSend;
    if (atSend == null) {
      return null;
    }
    return presentCount == atSend
        ? 'expression check: PASS — no overlay presented'
        : 'expression check: FAIL — overlay presented despite a non-matching expression';
  }
}

/// Storage Sharing's bookkeeping and verdict, mirroring the RN screen: the inline reader reports
/// every poll through custom actions, the overlay writer reports the completed write, and the
/// verdict tells a frozen reader WebView apart from a storage value that never became visible.
class StorageVerdict {
  int pollTickCount = 0;
  String lastPolledValue = 'never polled';
  String? resolvedValue;
  String? writtenValue;
  bool isPollExhausted = false;
  int overlayPresentCount = 0;
  int? pollTickCountAtOverlayPresent;
  int? pollTicksDuringOverlay;

  void recordTick(String? value) {
    pollTickCount++;
    lastPolledValue = value ?? 'null';
  }

  void recordResolved(String? value) => resolvedValue = value;

  void recordExhausted() => isPollExhausted = true;

  void recordOverlayPresent() {
    overlayPresentCount++;
    pollTickCountAtOverlayPresent = pollTickCount;
  }

  void recordOverlayHide() {
    final int? atPresent = pollTickCountAtOverlayPresent;
    if (atPresent != null) {
      pollTicksDuringOverlay = pollTickCount - atPresent;
    }
  }

  void recordWriteDone(String? value) => writtenValue = value;

  String get writtenLabel => writtenValue ?? 'nothing yet';

  String get ticksDuringOverlayLabel {
    final int? ticks = pollTicksDuringOverlay;
    if (ticks != null) {
      return '$ticks';
    }
    return pollTickCountAtOverlayPresent == null ? 'n/a' : 'overlay still displayed';
  }

  String get verdict {
    final String? resolved = resolvedValue;
    if (resolved != null) {
      return 'storage check: PASS — inline read "$resolved" written by the overlay';
    }
    if (overlayPresentCount == 0) {
      return 'storage check: mount the reader, then trigger the overlay writer';
    }
    if (writtenValue == null) {
      return 'storage check: INCONCLUSIVE — the overlay never reported a completed write';
    }
    if (pollTicksDuringOverlay == 0) {
      return 'storage check: FAIL — reader JS froze while the overlay was displayed (0 ticks)';
    }
    if (isPollExhausted) {
      return 'storage check: FAIL — reader kept polling but never saw the overlay write';
    }
    return 'storage check: waiting — reader still polling';
  }
}

/// Whether the overlay and inline in-app listeners implement the link callbacks.
enum InAppListenerMode { claimsLinks, claimsNothing }

/// What the injector listener does with a link: only log it, or delegate to the SDK opener.
enum InjectorListenerMode { logsOnly, delegatesToSdk }

/// The two switches of the URL & Deeplink Actions routing matrix, with the RN labels and the
/// `expect:` line the runner compares the log against.
class LinkRoutingModes {
  InAppListenerMode inAppListenerMode = InAppListenerMode.claimsLinks;
  InjectorListenerMode injectorListenerMode = InjectorListenerMode.logsOnly;

  String get inAppListenerLabel => inAppListenerMode == InAppListenerMode.claimsLinks
      ? 'in-app listeners CLAIM links (onOpenUrl / onDeepLink implemented)'
      : 'in-app listeners CLAIM NOTHING (link handlers omitted)';

  String get injectorListenerLabel => injectorListenerMode == InjectorListenerMode.logsOnly
      ? 'injector LOGS ONLY — nothing opens'
      : 'injector DELEGATES to SDK — the target opens';

  String get expectation {
    final String inAppPart = inAppListenerMode == InAppListenerMode.claimsLinks
        ? 'overlay/inline listener fires'
        : 'overlay/inline listener SILENT';
    final String openPart =
        injectorListenerMode == InjectorListenerMode.delegatesToSdk ? 'target opens' : 'nothing opens';
    return '$inAppPart · INJECTOR fires with the source · $openPart';
  }

  void toggleInAppListenerMode() {
    inAppListenerMode = inAppListenerMode == InAppListenerMode.claimsLinks
        ? InAppListenerMode.claimsNothing
        : InAppListenerMode.claimsLinks;
  }

  void toggleInjectorListenerMode() {
    injectorListenerMode = injectorListenerMode == InjectorListenerMode.logsOnly
        ? InjectorListenerMode.delegatesToSdk
        : InjectorListenerMode.logsOnly;
  }
}

/// Configures the SDK's overlay in-app listener the way RN *replaces* it: every callback is assigned,
/// `null` where the screen provides nothing. The Flutter listener is a singleton whose fields survive
/// across screens, so a screen that only sets what it needs would inherit the previous screen's
/// callbacks — and the "CLAIM NOTHING" mode of the routing matrix would silently claim links.
void setOverlayListener({
  void Function(InAppMessageData data)? onPresent,
  void Function(InAppMessageData data)? onHide,
  void Function(InAppMessageData data, String url)? onOpenUrl,
  void Function(InAppMessageData data, String deepLink)? onDeepLink,
  void Function(InAppMessageData data, String name, Map<String, String> parameters)? onCustomAction,
  void Function(InAppMessageData data, String name, Map<String, dynamic> parameters,
          InAppCustomMethodCompletion completion)?
      onCustomMethod,
}) {
  Synerise.injector.inAppMessageListener((listener) {
    listener.onPresent = onPresent;
    listener.onHide = onHide;
    listener.onOpenUrl = onOpenUrl;
    listener.onDeepLink = onDeepLink;
    listener.onCustomAction = onCustomAction;
    listener.onCustomMethod = onCustomMethod;
  });
}

/// Formats a map for the log the way the RN screens do (`JSON.stringify`), falling back to
/// `toString` for values `jsonEncode` rejects.
String describeParameters(Object? parameters) {
  try {
    return jsonEncode(parameters);
  } catch (_) {
    return parameters.toString();
  }
}
