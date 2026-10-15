import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "Lifecycle" screen: placement key "lifecycle" with render()
/// and release() buttons; logs the mount/unmount lifecycle equivalents.
class InlineLifecycleScreen extends StatefulWidget {
  const InlineLifecycleScreen({super.key});

  @override
  State<InlineLifecycleScreen> createState() => _InlineLifecycleScreenState();
}

class _InlineLifecycleScreenState extends State<InlineLifecycleScreen>
    with InlineSampleLog<InlineLifecycleScreen> {
  static const String _placementKey = 'lifecycle';

  final InlineInAppViewController _controller = InlineInAppViewController();

  @override
  void initState() {
    super.initState();
    appendLog('init', 'created with key=$_placementKey');
    appendLog('lifecycle', 'onMount');
    registerInlineListener(log: appendLog);
  }

  @override
  void dispose() {
    appendLog('lifecycle', 'onUnmount');
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  void _render() {
    appendLog('action', 'render() called');
    _controller.render();
  }

  void _release() {
    appendLog('action', 'release() called');
    _controller.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lifecycle')),
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
                ElevatedButton(onPressed: _release, child: const Text('release()')),
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
