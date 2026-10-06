import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "Priority" screen: placement key "priority" with render(),
/// plus two event triggers of differing priority.
class InlinePriorityScreen extends StatefulWidget {
  const InlinePriorityScreen({super.key});

  @override
  State<InlinePriorityScreen> createState() => _InlinePriorityScreenState();
}

class _InlinePriorityScreenState extends State<InlinePriorityScreen>
    with InlineSampleLog<InlinePriorityScreen> {
  static const String _placementKey = 'priority';

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

  void _sendEvent(String eventName, String label) {
    appendLog('action', 'sending event: $eventName');
    Synerise.tracker.send(CustomEvent(label, eventName, null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Priority')),
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
                ElevatedButton(onPressed: _render, child: const Text('render()')),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _sendEvent('inline.priority', 'Priority trigger event'),
                  child: const Text('send inline.priority'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _sendEvent('inline.priorityhigh', 'Priority high trigger'),
                  child: const Text('send inline.priorityhigh'),
                ),
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
