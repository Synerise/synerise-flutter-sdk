import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import '../overlay/overlay_sample_support.dart' show RotationCheck, RotationCheckKind;
import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "Rotation" screen: placement key "rotationinline" auto-renders;
/// rotate the device to verify the inline survives configuration changes without re-triggering.
/// The `rotation check` line compares onLoaded/onFailed counts before and after the last rotation.
class InlineRotationScreen extends StatefulWidget {
  const InlineRotationScreen({super.key});

  @override
  State<InlineRotationScreen> createState() => _InlineRotationScreenState();
}

class _InlineRotationScreenState extends State<InlineRotationScreen>
    with InlineSampleLog<InlineRotationScreen> {
  static const String _placementKey = 'rotationinline';

  final RotationCheck _rotationCheck = RotationCheck(RotationCheckKind.inline);
  final InlineInAppViewController _controller = InlineInAppViewController();

  @override
  void initState() {
    super.initState();
    appendLog('init', 'created with key=$_placementKey');
    appendLog('hint', 'rotate the device — the inline should survive without re-triggering callbacks');
    registerInlineListener(log: appendLog);
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  void _recordOrientation(String orientation, Size size) {
    if (!mounted || !_rotationCheck.recordOrientation(orientation)) {
      return;
    }
    appendLog('orientation', '$orientation ${size.width.round()}x${size.height.round()}');
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String orientation = size.width > size.height ? 'landscape' : 'portrait';
    WidgetsBinding.instance.addPostFrameCallback((_) => _recordOrientation(orientation, size));

    return Scaffold(
      appBar: AppBar(title: const Text('Rotation')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text('Placement: $_placementKey (rotate the device)',
                    style: TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                    'orientation: $orientation · onLoaded: ${_rotationCheck.primaryCount}× · onFailed: ${_rotationCheck.secondaryCount}×',
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                Text(_rotationCheck.verdict, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                SizedBox(
                  height: 300,
                  child: InlineInAppView(
                    placementKey: _placementKey,
                    controller: _controller,
                    onProcessingStarted: () => appendLog('onProcessingStarted', ''),
                    onLoaded: (data) {
                      setState(() => _rotationCheck.recordPrimary());
                      appendLog('onLoaded', 'hash=${data.campaignHash}');
                    },
                    onUpdated: (data) => appendLog('onUpdated', 'hash=${data.campaignHash}'),
                    onFailed: (data, error) {
                      setState(() => _rotationCheck.recordSecondary());
                      appendLog('onFailed', error);
                    },
                    onRemove: (data) {
                      appendLog('onRemove', 'hash=${data.campaignHash}');
                      appendLog('action', 'release() — full reset after onRemove');
                      _controller.release();
                    },
                    onSizeChanged: (data, size) =>
                        appendLog('onSizeChanged', 'w=${size.width} h=${size.height}'),
                  ),
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
