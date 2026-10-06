import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's search target: placement key "searchtop" mounted AUTOMATIC on
/// this screen, logging timing relative to screen mount so the preload benefit can be compared.
class InlineSearchScreen extends StatefulWidget {
  const InlineSearchScreen({super.key});

  @override
  State<InlineSearchScreen> createState() => _InlineSearchScreenState();
}

class _InlineSearchScreenState extends State<InlineSearchScreen>
    with InlineSampleLog<InlineSearchScreen> {
  static const String _placementKey = 'searchtop';

  late final DateTime _mountedAt;

  @override
  void initState() {
    super.initState();
    _mountedAt = DateTime.now();
    appendLog('init', 'created key=$_placementKey (AUTOMATIC)');
    registerInlineListener(log: appendLog);
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  int _sinceMount() => DateTime.now().difference(_mountedAt).inMilliseconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search screen')),
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
                  child: InlineInAppView(
                    placementKey: _placementKey,
                    onProcessingStarted: () => appendLog('onProcessingStarted', ''),
                    onLoaded: (data) =>
                        appendLog('onLoaded', '+${_sinceMount()}ms hash=${data.campaignHash}'),
                    onUpdated: (data) =>
                        appendLog('onUpdated', '+${_sinceMount()}ms hash=${data.campaignHash}'),
                    onFailed: (data, error) => appendLog('onFailed', '+${_sinceMount()}ms $error'),
                    onRemove: (data) => appendLog('onRemove', '+${_sinceMount()}ms'),
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
