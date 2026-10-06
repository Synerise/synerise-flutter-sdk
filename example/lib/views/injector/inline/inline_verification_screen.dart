import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Covers the three inline edge cases no other sample screen can reach, because each of them fails a
/// different precondition: Debug's Clear unmounts the widget, Lifecycle's key has no ON_DEMAND
/// campaign, and nothing calls render() before the platform view exists.
///
/// D2 — render() is issued from initState, before the platform channel is created, so the Dart
///      controller has to queue it in _renderPending and replay it on attach.
/// D1 — release() keeps the widget mounted, so a following render() exercises the native
///      "host unregistered" path on a key that really does have an ON_DEMAND campaign.
class InlineVerificationScreen extends StatefulWidget {
  /// How many render() calls initState issues before the platform view exists. More than one probes
  /// whether the controller coalesces them, since _renderPending is a flag rather than a queue.
  final int queuedRenderCount;

  const InlineVerificationScreen({super.key, this.queuedRenderCount = 1});

  @override
  State<InlineVerificationScreen> createState() => _InlineVerificationScreenState();
}

class _InlineVerificationScreenState extends State<InlineVerificationScreen> {
  /// Campaign 5 lives here as ON_DEMAND, which is what makes the D1 branch reachable at all.
  static const String _placementKey = 'demand';

  final InlineInAppViewController _controller = InlineInAppViewController();
  final List<String> _log = <String>[];

  bool _renderQueuedBeforeAttach = false;
  int _loadedCount = 0;
  int _failedCount = 0;
  int? _loadedCountAtRelease;
  int? _failedCountAtRelease;
  bool _releaseCalled = false;

  @override
  void initState() {
    super.initState();
    appendLog('init', 'calling render() ${widget.queuedRenderCount}× from initState — '
        'before the platform view exists');
    _renderQueuedBeforeAttach = true;
    for (int attempt = 0; attempt < widget.queuedRenderCount; attempt++) {
      _controller.render();
    }
  }

  void appendLog(String tag, String message) {
    final DateTime now = DateTime.now();
    final String time = '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';
    setState(() => _log.add('$time [$tag] $message'));
  }

  void _onViewCallback(String tag, String message) {
    if (tag == 'onLoaded' || tag == 'onUpdated') {
      _loadedCount++;
    } else if (tag == 'onFailed') {
      _failedCount++;
    }
    appendLog(tag, message);
  }

  void _render() {
    appendLog('action', 'render() called');
    _controller.render();
  }

  void _release() {
    _loadedCountAtRelease = _loadedCount;
    _failedCountAtRelease = _failedCount;
    _releaseCalled = true;
    appendLog('action', 'release() called — widget stays mounted');
    _controller.release();
  }

  Future<void> _readState() async {
    final bool rendered = await _controller.isRendered();
    final InlineInAppMessageData? data = await _controller.getData();
    appendLog('state', 'isRendered=$rendered getData=${data?.campaignHash ?? 'null'}');
  }

  String get _queuedRenderVerdict {
    if (!_renderQueuedBeforeAttach) {
      return 'D2: not exercised';
    }
    if (_loadedCount == 0 && _failedCount == 0) {
      return 'D2: queued render produced NO callback at all — silent skip';
    }
    if (_loadedCount > 0) {
      return 'D2: queued render reached the campaign — onLoaded fired';
    }
    return 'D2: queued render answered with onFailed only';
  }

  String get _afterReleaseVerdict {
    if (!_releaseCalled) {
      return 'D1: press release(), then render() again';
    }
    final int loadedDelta = _loadedCount - (_loadedCountAtRelease ?? 0);
    final int failedDelta = _failedCount - (_failedCountAtRelease ?? 0);
    if (loadedDelta == 0 && failedDelta == 0) {
      return 'D1: render() after release() was SILENT — no callback (confirms the thesis)';
    }
    if (failedDelta > 0 && loadedDelta == 0) {
      return 'D1: render() after release() answered onFailed ×$failedDelta';
    }
    return 'D1: render() after release() re-rendered — onLoaded ×$loadedDelta';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Placement "demand" (ON_DEMAND). render() is issued ${widget.queuedRenderCount}× from '
              'initState, so the first result below belongs to the queued render, not to a button. '
              'Compare the callback count here with "render() requested" lines in the SDK log.',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text('onLoaded/onUpdated: $_loadedCount · onFailed: $_failedCount',
                style: const TextStyle(fontSize: 13)),
            Text(_queuedRenderVerdict,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            Text(_afterReleaseVerdict,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 260,
              child: buildInlineView(
                placementKey: _placementKey,
                controller: _controller,
                log: _onViewCallback,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _render, child: const Text('render()')),
            const SizedBox(height: 6),
            ElevatedButton(onPressed: _release, child: const Text('release() — keeps widget mounted')),
            const SizedBox(height: 6),
            ElevatedButton(onPressed: _readState, child: const Text('isRendered() / getData()')),
            const SizedBox(height: 14),
            const Text('Callback Log:', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 4),
            Text(_log.join('\n'),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
