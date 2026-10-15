import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "Global Listener" screen: no InlineInAppView is declared up
/// front. When onInlineInAppAvailable hands over the SDK-rendered view, the screen mounts that exact
/// view (through its adoptViewId) instead of rendering the placement again.
class InlineGlobalListenerScreen extends StatefulWidget {
  const InlineGlobalListenerScreen({super.key});

  @override
  State<InlineGlobalListenerScreen> createState() => _InlineGlobalListenerScreenState();
}

class _InlineGlobalListenerScreenState extends State<InlineGlobalListenerScreen>
    with InlineSampleLog<InlineGlobalListenerScreen> {
  InlineInAppView? _sdkView;

  @override
  void initState() {
    super.initState();
    appendLog('init', 'No InlineInAppView registered. Registering global listener.');
    registerInlineListener(
      log: appendLog,
      groupTag: 'GLOBAL',
      onAvailable: (view, data) => setState(() => _sdkView = buildInlineView(
            placementKey: data.placementKey,
            adoptViewId: view.adoptViewId,
            log: appendLog,
          )),
    );
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  void _sendGlobalEvent() {
    const String eventName = 'inline.global';
    appendLog('action', 'sending event: $eventName');
    Synerise.tracker.send(CustomEvent('Global listener trigger', eventName, null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Global Listener')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text('SDK-rendered view mounts below when available',
                    style: TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                SizedBox(
                  height: 300,
                  child: _sdkView ?? const SizedBox.shrink(),
                ),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _sendGlobalEvent, child: const Text('send inline.global')),
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
