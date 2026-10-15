import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'overlay_sample_support.dart';

/// Mirror of the RN sample's "Storage Sharing" screen: cross-in-app SRInApp.storage visibility. An
/// inline creative polls getItem while an overlay creative writes the same key. Both creatives report
/// progress through handleCustomAction, so the screen can separate "the write was never visible" from
/// "the inline WebView stopped running under the overlay". Campaigns 36 (inline, placement
/// "storagereader") and 37 (overlay, event "overlay.storagewrite").
class InAppStorageSharingScreen extends StatefulWidget {
  const InAppStorageSharingScreen({super.key});

  @override
  State<InAppStorageSharingScreen> createState() => _InAppStorageSharingScreenState();
}

class _InAppStorageSharingScreenState extends State<InAppStorageSharingScreen>
    with InlineSampleLog<InAppStorageSharingScreen> {
  static const String _readerPlacementKey = 'storagereader';
  static const String _writerEventAction = 'overlay.storagewrite';
  static const String _sharedStorageKey = 'zaGroszSku';
  static const double _readerContainerHeight = 200;
  static const double _logHeight = 240;

  static const String _pollTickAction = 'storagePollTick';
  static const String _pollResolvedAction = 'storagePollResolved';
  static const String _pollExhaustedAction = 'storagePollExhausted';
  static const String _writeDoneAction = 'storageWriteDone';

  final StorageVerdict _verdict = StorageVerdict();

  @override
  void initState() {
    super.initState();
    appendLog('init', 'reader key=$_readerPlacementKey storageKey=$_sharedStorageKey');

    Synerise.injector.inlineInAppMessageListener((listener) {
      listener.onInlineInAppAvailable =
          (view, data) => appendLog('GLOBAL', 'inline available key=${data.placementKey}');
      listener.onOpenUrl = (data, url) => appendLog('READER', 'onOpenUrl $url');
      listener.onDeepLink = (data, deepLink) => appendLog('READER', 'onDeepLink $deepLink');
      listener.onCustomAction = (data, name, parameters) => _handleReaderCustomAction(name, parameters);
      listener.onCustomMethod = (data, name, parameters, completion) {
        appendLog('READER', 'onCustomMethod $name');
        completion.success(parameters);
      };
    });

    setOverlayListener(
      onPresent: (data) {
        if (!mounted) return;
        setState(() => _verdict.recordOverlayPresent());
        appendLog('WRITER',
            'onPresent hash=${data.campaignHash} readerTicksSoFar=${_verdict.pollTickCountAtOverlayPresent}');
      },
      onHide: (data) {
        if (!mounted) return;
        setState(() => _verdict.recordOverlayHide());
        appendLog('WRITER',
            'onHide readerTicksDuringOverlay=${_verdict.pollTicksDuringOverlay ?? 'n/a'}');
      },
      onOpenUrl: (data, url) => appendLog('WRITER', 'onOpenUrl $url'),
      onDeepLink: (data, deepLink) => appendLog('WRITER', 'onDeepLink $deepLink'),
      onCustomAction: (data, name, parameters) {
        if (!mounted) return;
        if (name == _writeDoneAction) {
          setState(() => _verdict.recordWriteDone(parameters['value']));
        }
        appendLog('WRITER', '$name ${describeParameters(parameters)}');
      },
    );
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  String? _readParameter(Map<String, dynamic> parameters, String name) {
    final Object? value = parameters[name];
    return value?.toString();
  }

  void _handleReaderCustomAction(String name, Map<String, dynamic> parameters) {
    if (!mounted) return;
    if (name == _pollTickAction) {
      setState(() => _verdict.recordTick(_readParameter(parameters, 'value')));
      return;
    }
    if (name == _pollResolvedAction) {
      setState(() => _verdict.recordResolved(_readParameter(parameters, 'value')));
      appendLog('READER', 'resolved $_sharedStorageKey=${describeParameters(parameters)}');
      return;
    }
    if (name == _pollExhaustedAction) {
      setState(() => _verdict.recordExhausted());
      appendLog('READER', 'poll exhausted without a value ${describeParameters(parameters)}');
      return;
    }
    appendLog('READER', '$name ${describeParameters(parameters)}');
  }

  void _triggerOverlayWriter() {
    appendLog('action', 'sending EVENT: $_writerEventAction');
    Synerise.tracker.send(CustomEvent('Storage sharing writer', _writerEventAction, null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Storage Sharing')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'The inline creative polls SRInApp.storage.getItem("$_sharedStorageKey") and '
                    'reports every attempt. Trigger the overlay, which writes the same key. Ticks '
                    'continuing while the overlay is up prove the reader is alive, so a missing value '
                    'is a storage problem and not a frozen WebView.',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Text('reader ticks: ${_verdict.pollTickCount}', style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('last polled value: ${_verdict.lastPolledValue}',
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('overlay wrote: ${_verdict.writtenLabel}', style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('ticks during overlay: ${_verdict.ticksDuringOverlayLabel}',
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(_verdict.verdict, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: _triggerOverlayWriter, child: const Text('Trigger overlay writer')),
                  const SizedBox(height: 8),
                  const Text('reader key: $_readerPlacementKey', style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: _readerContainerHeight,
                    child: InlineInAppView(
                      placementKey: _readerPlacementKey,
                      onProcessingStarted: () => appendLog('reader', 'onProcessingStarted'),
                      onLoaded: (data) => appendLog('reader', 'onLoaded hash=${data.campaignHash}'),
                      onUpdated: (data) => appendLog('reader', 'onUpdated hash=${data.campaignHash}'),
                      onFailed: (data, error) => appendLog('reader', 'onFailed: $error'),
                      onRemove: (data) => appendLog('reader', 'onRemove'),
                      onSizeChanged: (data, size) =>
                          appendLog('reader', 'onSizeChanged w=${size.width} h=${size.height}'),
                    ),
                  ),
                ],
              ),
            ),
            callbackLogLabel,
            SizedBox(height: _logHeight, child: buildLogScroll()),
          ],
        ),
      ),
    );
  }
}
