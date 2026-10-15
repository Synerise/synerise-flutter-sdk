import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN sample's "Dynamic" screen: placement key "dynamic" backed by an ON_DEMAND
/// campaign with a dynamic variant, so nothing renders until render() is pressed. A dynamic variant
/// is rendered server-side, which is the only path (besides a force-segment audience) where the SDK
/// asks the app for context; "Set jinjavaContext" seeds the context the SDK then hands over.
class InlineDynamicScreen extends StatefulWidget {
  const InlineDynamicScreen({super.key});

  @override
  State<InlineDynamicScreen> createState() => _InlineDynamicScreenState();
}

class _InlineDynamicScreenState extends State<InlineDynamicScreen>
    with InlineSampleLog<InlineDynamicScreen> {
  static const String _placementKey = 'dynamic';
  static const double _containerHeight = 300;

  final InlineInAppViewController _controller = InlineInAppViewController();
  double _currentHeight = _containerHeight;

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

  void _setJinjavaContext() {
    Synerise.injector.inAppContext[InAppContextKey.jinjavaContext] = <String, Object>{
      'tier': 'gold',
      'cart': 3,
    };
    appendLog('jinjava', "set jinjavaContext = { tier: 'gold', cart: 3 }");
  }

  void _render() {
    appendLog('action', 'render() called');
    _controller.render();
  }

  Future<void> _isRendered() async {
    final bool isRendered = await _controller.isRendered();
    appendLog('action', 'isRendered() -> $isRendered');
  }

  void _onLoaded(InlineInAppMessageData data) {
    appendLog('onLoaded', 'hash=${data.campaignHash}');
    setState(() => _currentHeight = _containerHeight);
  }

  void _onUpdated(InlineInAppMessageData data) {
    appendLog('onUpdated', 'hash=${data.campaignHash}');
    setState(() => _currentHeight = _containerHeight);
  }

  /// Mirrors the RN sample: collapse the container, then release() for a full reset.
  void _onRemove(InlineInAppMessageData data) {
    appendLog('onRemove', '');
    setState(() => _currentHeight = 0);
    appendLog('action', 'release() — full reset after onRemove');
    _controller.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic (render)')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text('Placement: $_placementKey | ON_DEMAND, dynamic variant',
                    style: TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                SizedBox(
                  height: _currentHeight,
                  child: InlineInAppView(
                    placementKey: _placementKey,
                    controller: _controller,
                    onProcessingStarted: () => appendLog('onProcessingStarted', ''),
                    onLoaded: _onLoaded,
                    onUpdated: _onUpdated,
                    onFailed: (data, error) => appendLog('onFailed', error),
                    onRemove: _onRemove,
                    onSizeChanged: (data, size) =>
                        appendLog('onSizeChanged', 'w=${size.width} h=${size.height}'),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _setJinjavaContext, child: const Text('Set jinjavaContext')),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _render, child: const Text('render()')),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _isRendered, child: const Text('isRendered()')),
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
