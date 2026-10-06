import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "Auto Resize" screen: placement key "autoresize"; the container
/// starts at height 0 and grows from onSizeChanged, shrinking back to 0 on reset and on onRemove.
class InlineAutoResizeScreen extends StatefulWidget {
  const InlineAutoResizeScreen({super.key});

  @override
  State<InlineAutoResizeScreen> createState() => _InlineAutoResizeScreenState();
}

class _InlineAutoResizeScreenState extends State<InlineAutoResizeScreen>
    with InlineSampleLog<InlineAutoResizeScreen> {
  static const String _placementKey = 'autoresize';

  final InlineInAppViewController _controller = InlineInAppViewController();
  double _componentHeight = 0;

  @override
  void initState() {
    super.initState();
    appendLog('init', 'created key=$_placementKey size=0x0');
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

  void _reset() {
    appendLog('resize', 'component rescaled to 0x0');
    setState(() => _componentHeight = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auto Resize')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Placement: $_placementKey (current height: ${_componentHeight.round()})',
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                SizedBox(
                  height: _componentHeight,
                  child: buildInlineView(
                    placementKey: _placementKey,
                    controller: _controller,
                    log: appendLog,
                    onSizeChanged: (data, size) {
                      appendLog('onSizeChanged', 'w=${size.width} h=${size.height} px=${size.widthPx}x${size.heightPx}');
                      setState(() => _componentHeight = size.height);
                    },
                    onRemove: (data) {
                      appendLog('onRemove', '');
                      setState(() => _componentHeight = 0);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _render, child: const Text('render()')),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _reset, child: const Text('reset (height 0)')),
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
