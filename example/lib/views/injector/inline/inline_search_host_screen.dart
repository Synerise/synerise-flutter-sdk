import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';
import 'inline_search_screen.dart';

/// Mirror of the RN/Android sample's search host: placement key "searchtop" is mounted (preloaded)
/// as soon as the screen appears; a button opens the dedicated search screen. Timing is logged
/// (mount time vs onLoaded time) to show the preload.
class InlineSearchHostScreen extends StatefulWidget {
  const InlineSearchHostScreen({super.key});

  @override
  State<InlineSearchHostScreen> createState() => _InlineSearchHostScreenState();
}

class _InlineSearchHostScreenState extends State<InlineSearchHostScreen>
    with InlineSampleLog<InlineSearchHostScreen> {
  static const String _placementKey = 'searchtop';

  late final DateTime _mountedAt;

  @override
  void initState() {
    super.initState();
    _mountedAt = DateTime.now();
    appendLog('init', 'pre-rendering key=$_placementKey');
    registerInlineListener(log: appendLog);
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  int _sinceMount() => DateTime.now().difference(_mountedAt).inMilliseconds;

  void _openSearch() {
    appendLog('search', 'opening search screen (preloaded ${_sinceMount()}ms earlier)');
    Navigator.push(context, MaterialPageRoute(builder: (context) => const InlineSearchScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Preloaded placement: $_placementKey', style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                SizedBox(
                  height: 200,
                  child: InlineInAppView(
                    placementKey: _placementKey,
                    onProcessingStarted: () => appendLog('onProcessingStarted', ''),
                    onLoaded: (data) =>
                        appendLog('onLoaded', '+${_sinceMount()}ms after mount, hash=${data.campaignHash}'),
                    onUpdated: (data) => appendLog('onUpdated', 'hash=${data.campaignHash}'),
                    onFailed: (data, error) => appendLog('onFailed', error),
                    onRemove: (data) => appendLog('onRemove', ''),
                    onSizeChanged: (data, size) =>
                        appendLog('onSizeChanged', 'w=${size.width} h=${size.height}'),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _openSearch, child: const Text('Open search screen')),
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
