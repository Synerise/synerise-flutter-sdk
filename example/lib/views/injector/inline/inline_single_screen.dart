import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "Single Placement" screen: placement key "single",
/// per-view + global callbacks logged, and a render() button for ON_DEMAND campaigns.
class InlineSingleScreen extends StatefulWidget {
  const InlineSingleScreen({super.key});

  @override
  State<InlineSingleScreen> createState() => _InlineSingleScreenState();
}

class _InlineSingleScreenState extends State<InlineSingleScreen>
    with InlineSampleLog<InlineSingleScreen> {
  static const String _placementKey = 'single';

  final InlineInAppViewController _controller = InlineInAppViewController();

  @override
  void initState() {
    super.initState();
    appendLog('init', 'created with key=$_placementKey');
    registerInlineListener(log: appendLog);
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  void _render() {
    appendLog('action', 'render() called');
    _controller.render();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Single Placement')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Placement: $_placementKey', style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                SizedBox(
                  height: 300,
                  child: buildInlineView(placementKey: _placementKey, controller: _controller, log: appendLog),
                ),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _render, child: const Text('render() (ON_DEMAND)')),
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
