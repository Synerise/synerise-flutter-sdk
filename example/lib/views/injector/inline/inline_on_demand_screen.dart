import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "On Demand" screen: placement key "demand" rendered on demand
/// via render(), plus an event trigger button.
class InlineOnDemandScreen extends StatefulWidget {
  const InlineOnDemandScreen({super.key});

  @override
  State<InlineOnDemandScreen> createState() => _InlineOnDemandScreenState();
}

class _InlineOnDemandScreenState extends State<InlineOnDemandScreen>
    with InlineSampleLog<InlineOnDemandScreen> {
  static const String _placementKey = 'demand';

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

  void _sendTriggerEvent() {
    const String eventName = 'inline.trigger';
    appendLog('action', 'sending event: $eventName');
    Synerise.tracker.send(CustomEvent('Inline trigger event', eventName, <String, Object>{
      'my_source': 'on_demand_screen',
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('On Demand')),
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
                ElevatedButton(onPressed: _sendTriggerEvent, child: const Text('send inline.trigger')),
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
