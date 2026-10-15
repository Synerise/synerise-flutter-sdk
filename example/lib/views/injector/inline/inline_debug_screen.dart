import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "Debug" screen: a text input for an arbitrary placement key,
/// Create (mount the view), render(), and Clear (unmount/release).
class InlineDebugScreen extends StatefulWidget {
  const InlineDebugScreen({super.key});

  @override
  State<InlineDebugScreen> createState() => _InlineDebugScreenState();
}

class _InlineDebugScreenState extends State<InlineDebugScreen>
    with InlineSampleLog<InlineDebugScreen> {
  final InlineInAppViewController _controller = InlineInAppViewController();
  final TextEditingController _placementKeyInput = TextEditingController();
  String? _mountedPlacementKey;

  @override
  void initState() {
    super.initState();
    registerInlineListener(log: appendLog);
  }

  @override
  void dispose() {
    _placementKeyInput.dispose();
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  void _create() {
    final String key = _placementKeyInput.text.trim();
    if (key.isEmpty) {
      appendLog('action', 'placementKey is empty');
      return;
    }
    _clear();
    setState(() => _mountedPlacementKey = key);
    appendLog('action', 'created key=$key');
  }

  /// Mounting an empty key is normally a mistake, so _create rejects it. This exercises it on
  /// purpose: Android registers "" and answers onFailed, iOS never creates the view and stays silent.
  void _createWithEmptyKey() {
    _clear();
    setState(() => _mountedPlacementKey = '');
    appendLog('action', 'created with EMPTY key');
  }

  void _clear() {
    if (_mountedPlacementKey != null) {
      _controller.release();
      setState(() => _mountedPlacementKey = null);
      appendLog('action', 'component cleared');
    }
  }

  void _render() {
    if (_mountedPlacementKey == null) {
      appendLog('action', 'no component — tap Create first');
      return;
    }
    appendLog('action', 'render() called');
    _controller.render();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _placementKeyInput,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: const InputDecoration(
                    labelText: 'placementKey',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _create, child: const Text('Create')),
                const SizedBox(height: 6),
                ElevatedButton(
                    onPressed: _createWithEmptyKey, child: const Text('Create with EMPTY key')),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _render, child: const Text('render()')),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _clear, child: const Text('Clear')),
                const SizedBox(height: 8),
                SizedBox(
                  height: 300,
                  child: _mountedPlacementKey == null
                      ? const SizedBox.shrink()
                      : buildInlineView(
                          placementKey: _mountedPlacementKey!, controller: _controller, log: appendLog),
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
