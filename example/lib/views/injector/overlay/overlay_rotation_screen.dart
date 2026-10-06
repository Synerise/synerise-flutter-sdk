import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'overlay_sample_support.dart';

/// Mirror of the RN sample's "Overlay Rotation" screen: trigger the overlay, then rotate. The SDK
/// must keep the same overlay across the orientation change — onPresent stays at 1, onHide at 0.
/// Campaign 30 (OVERLAY MODAL, event "overlay.rotation").
///
/// Platform note: the Flutter sample's Android manifest declares `configChanges` including
/// orientation, so the Activity is not recreated on rotation (the RN sample behaves the same). The
/// native Android sample's "re-show after Activity recreation" path therefore does not run here; the
/// screen verifies survival of an orientation change without a second onPresent or an onHide.
class OverlayRotationScreen extends StatefulWidget {
  const OverlayRotationScreen({super.key});

  @override
  State<OverlayRotationScreen> createState() => _OverlayRotationScreenState();
}

class _OverlayRotationScreenState extends State<OverlayRotationScreen>
    with InlineSampleLog<OverlayRotationScreen> {
  static const String _triggerEventAction = 'overlay.rotation';

  final RotationCheck _rotationCheck = RotationCheck(RotationCheckKind.overlay);

  @override
  void initState() {
    super.initState();
    appendLog('init', 'Overlay listener registered — trigger, then rotate the device');
    setOverlayListener(
      onPresent: (data) {
        if (!mounted) return;
        setState(() => _rotationCheck.recordPrimary());
        appendLog('onPresent', 'hash=${data.campaignHash}');
      },
      onHide: (data) {
        if (!mounted) return;
        setState(() => _rotationCheck.recordSecondary());
        appendLog('onHide', 'hash=${data.campaignHash}');
      },
      onOpenUrl: (data, url) => appendLog('onOpenUrl', url),
      onDeepLink: (data, deepLink) => appendLog('onDeepLink', deepLink),
    );
  }

  void _recordOrientation(String orientation, Size size) {
    if (!mounted || !_rotationCheck.recordOrientation(orientation)) {
      return;
    }
    appendLog('orientation', '$orientation ${size.width.round()}x${size.height.round()}');
  }

  void _triggerOverlay() {
    appendLog('action', 'sending EVENT: $_triggerEventAction');
    Synerise.tracker.send(CustomEvent('Overlay rotation trigger', _triggerEventAction, null));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String orientation = size.width > size.height ? 'landscape' : 'portrait';
    WidgetsBinding.instance.addPostFrameCallback((_) => _recordOrientation(orientation, size));

    return Scaffold(
      appBar: AppBar(title: const Text('Overlay Rotation')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Trigger the overlay, then rotate. The SDK re-shows the same WebView, so onPresent '
                  'must stay at 1 and onHide at 0 — a second onPresent means the overlay was '
                  're-rendered, an onHide means it was discarded.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                Text('orientation: $orientation', style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                    'onPresent: ${_rotationCheck.primaryCount}× · onHide: ${_rotationCheck.secondaryCount}×',
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                Text(_rotationCheck.verdict, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _triggerOverlay, child: const Text('Trigger overlay')),
              ],
            ),
          ),
          callbackLogLabel,
          Expanded(child: buildLogScroll()),
        ],
      ),
    );
  }
}
