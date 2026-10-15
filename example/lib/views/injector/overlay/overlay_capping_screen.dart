import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'overlay_sample_support.dart';

/// Mirror of the RN sample's "Overlay Capping" screen: fire the same overlay campaign repeatedly and
/// watch where it stops presenting. Capping is silent — a blocked campaign produces no overlay and no
/// callback — so the counters are the assertion. Campaigns 32 (event "overlay.cappinglife",
/// lifetime cap 2) and 33 (event "overlay.cappingtime", 2 per hour).
class OverlayCappingScreen extends StatefulWidget {
  const OverlayCappingScreen({super.key});

  @override
  State<OverlayCappingScreen> createState() => _OverlayCappingScreenState();
}

class _OverlayCappingScreenState extends State<OverlayCappingScreen>
    with InlineSampleLog<OverlayCappingScreen> {
  static const String _lifetimeEventAction = 'overlay.cappinglife';
  static const String _timeWindowEventAction = 'overlay.cappingtime';

  int _lifetimeSendCount = 0;
  int _timeWindowSendCount = 0;
  int _presentCount = 0;

  @override
  void initState() {
    super.initState();
    appendLog('init', 'Overlay listener registered');
    appendLog('init', 'Lifetime: 2 ever · Time window: 2 per hour');
    setOverlayListener(
      onPresent: (data) {
        if (!mounted) return;
        setState(() => _presentCount++);
        appendLog('onPresent', 'hash=${data.campaignHash}');
      },
      onHide: (data) => appendLog('onHide', 'hash=${data.campaignHash}'),
      onOpenUrl: (data, url) => appendLog('onOpenUrl', url),
      onDeepLink: (data, deepLink) => appendLog('onDeepLink', deepLink),
    );
  }

  void _sendLifetimeEvent() {
    setState(() => _lifetimeSendCount++);
    appendLog('action', 'send #$_lifetimeSendCount → $_lifetimeEventAction');
    Synerise.tracker.send(CustomEvent('Overlay lifetime capping', _lifetimeEventAction, null));
  }

  void _sendTimeWindowEvent() {
    setState(() => _timeWindowSendCount++);
    appendLog('action', 'send #$_timeWindowSendCount → $_timeWindowEventAction');
    Synerise.tracker.send(CustomEvent('Overlay time capping', _timeWindowEventAction, null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Overlay Capping')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Send repeatedly and compare sends against presentations. Capping is silent — a '
                  'blocked campaign produces no overlay and no callback, so the counters are the '
                  'assertion. Both campaigns present twice: lifetime caps forever, time-window caps '
                  'per hour.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                Text('lifetime sends: $_lifetimeSendCount · time-window sends: $_timeWindowSendCount',
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                Text('onPresent fired: $_presentCount×', style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                ElevatedButton(
                    onPressed: _sendLifetimeEvent, child: const Text('Send lifetime-capped event')),
                const SizedBox(height: 8),
                ElevatedButton(
                    onPressed: _sendTimeWindowEvent,
                    child: const Text('Send time-window-capped event')),
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
