import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "Same Key" screen: three InlineInAppView using the same
/// placement key "single", plus a fourth key "fourth"; plus event trigger buttons.
class InlineSameKeyScreen extends StatefulWidget {
  const InlineSameKeyScreen({super.key});

  @override
  State<InlineSameKeyScreen> createState() => _InlineSameKeyScreenState();
}

class _InlineSameKeyScreenState extends State<InlineSameKeyScreen>
    with InlineSampleLog<InlineSameKeyScreen> {
  static const String _placementKey = 'single';
  static const String _fourthPlacementKey = 'fourth';

  @override
  void initState() {
    super.initState();
    appendLog('Component1', 'created with key=$_placementKey');
    appendLog('Component2', 'created with key=$_placementKey');
    appendLog('Component3', 'created with key=$_placementKey');
    appendLog('Component4', 'created with key=$_fourthPlacementKey');
    registerInlineListener(log: appendLog, groupTag: 'GLOBAL');
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  void _sendEvent(String eventName, String label) {
    appendLog('action', 'sending event: $eventName');
    Synerise.tracker.send(CustomEvent(label, eventName, null));
  }

  Widget _view(String tag, String placementKey) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: buildTaggedInlineView(placementKey: placementKey, tag: tag, log: appendLog),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text(text, style: const TextStyle(fontSize: 13)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Same Key')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _label('Component1 / Component2 / Component3 key: $_placementKey'),
                  _view('Component1', _placementKey),
                  _view('Component2', _placementKey),
                  _view('Component3', _placementKey),
                  _label('Component4 key: $_fourthPlacementKey'),
                  _view('Component4', _fourthPlacementKey),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: ElevatedButton(
                      onPressed: () => _sendEvent('inline.samekey', 'Same key trigger'),
                      child: const Text('send inline.samekey'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: ElevatedButton(
                      onPressed: () => _sendEvent('overlay.test', 'Overlay test'),
                      child: const Text('send overlay.test'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          callbackLogLabel,
          SizedBox(height: 180, child: buildLogScroll()),
        ],
      ),
    );
  }
}
