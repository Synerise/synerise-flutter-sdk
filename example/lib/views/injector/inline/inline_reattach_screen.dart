import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "Reattach" screen: placement key "single" with
/// Detach / Attach / render() / release() buttons. In Flutter, unmounting/remounting the widget
/// (toggling it out of the tree) is the equivalent of Android's removeView()/addView().
/// Unlike native's temporary detach (pause + preserve), a Flutter remount is a full teardown, so
/// re-attach builds a fresh instance that re-renders and re-fires the show — reflected in the log.
class InlineReattachScreen extends StatefulWidget {
  const InlineReattachScreen({super.key});

  @override
  State<InlineReattachScreen> createState() => _InlineReattachScreenState();
}

class _InlineReattachScreenState extends State<InlineReattachScreen>
    with InlineSampleLog<InlineReattachScreen> {
  static const String _placementKey = 'single';

  final InlineInAppViewController _controller = InlineInAppViewController();
  bool _attached = true;

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

  void _detach() {
    if (!_attached) {
      appendLog('action', 'detach skipped — already detached');
      return;
    }
    appendLog('action', 'unmount — temporary detach (screen alive)');
    setState(() => _attached = false);
  }

  void _attach() {
    if (_attached) {
      appendLog('action', 'attach skipped — already attached');
      return;
    }
    appendLog('action', 'remount — re-attach (fresh instance; AUTOMATIC re-trigger + new show)');
    setState(() => _attached = true);
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
      appBar: AppBar(title: const Text('Reattach')),
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
                  child: _attached
                      ? buildInlineView(
                          placementKey: _placementKey, controller: _controller, log: appendLog)
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _detach, child: const Text('Detach')),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _attach, child: const Text('Attach')),
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
