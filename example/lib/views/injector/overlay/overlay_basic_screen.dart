import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'overlay_sample_support.dart';

/// Mirror of the RN sample's "Overlay Basic" screen: the overlay regression baseline — trigger,
/// present, hide, closeInAppMessage, isTest — plus an event whose campaign expression cannot match,
/// which must present nothing. Campaign 17 (OVERLAY MODAL, event "overlay.test") and campaign 34
/// (event "overlay.expressionFail", expression source=WEB).
class OverlayBasicScreen extends StatefulWidget {
  const OverlayBasicScreen({super.key});

  @override
  State<OverlayBasicScreen> createState() => _OverlayBasicScreenState();
}

class _OverlayBasicScreenState extends State<OverlayBasicScreen>
    with InlineSampleLog<OverlayBasicScreen> {
  static const String _triggerEventAction = 'overlay.test';
  static const String _expressionFailEventAction = 'overlay.expressionFail';

  final ExpressionCheck _expressionCheck = ExpressionCheck();
  String? _currentCampaignHash;
  int _hideCount = 0;

  @override
  void initState() {
    super.initState();
    appendLog('init', 'Overlay listener registered');
    setOverlayListener(
      onPresent: (data) {
        if (!mounted) return;
        setState(() {
          _currentCampaignHash = data.campaignHash;
          _expressionCheck.recordPresent();
        });
        appendLog('onPresent',
            'hash=${data.campaignHash} variant=${data.variantIdentifier} isTest=${data.isTest}');
      },
      onHide: (data) {
        if (!mounted) return;
        setState(() {
          _currentCampaignHash = null;
          _hideCount++;
        });
        appendLog('onHide', 'hash=${data.campaignHash}');
      },
      onOpenUrl: (data, url) => appendLog('onOpenUrl', url),
      onDeepLink: (data, deepLink) => appendLog('onDeepLink', deepLink),
      onCustomAction: (data, name, parameters) =>
          appendLog('onCustomAction', '$name params=${describeParameters(parameters)}'),
    );
  }

  void _triggerOverlay() {
    appendLog('action', 'sending EVENT: $_triggerEventAction');
    Synerise.tracker.send(CustomEvent('Overlay basic trigger', _triggerEventAction, null));
  }

  void _sendExpressionFailEvent() {
    setState(() => _expressionCheck.recordSend());
    appendLog('action', 'sending EVENT: $_expressionFailEventAction');
    appendLog('expect', 'campaign expression requires source=WEB — no overlay may appear');
    Synerise.tracker.send(CustomEvent('Overlay expression fail', _expressionFailEventAction, null));
  }

  void _closeOverlay() {
    final String? hash = _currentCampaignHash;
    if (hash == null) {
      appendLog('action', 'closeInAppMessage skipped — nothing presented');
      return;
    }
    appendLog('action', 'closeInAppMessage($hash)');
    Synerise.injector.closeInAppMessage(hash);
  }

  @override
  Widget build(BuildContext context) {
    final String? expressionVerdict = _expressionCheck.verdict;
    return Scaffold(
      appBar: AppBar(title: const Text('Overlay Basic')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('onPresent: ${_expressionCheck.presentCount}× · onHide: $_hideCount×',
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                Text('currently presented: ${_currentCampaignHash ?? 'none'}',
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _triggerOverlay, child: const Text('Trigger overlay')),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _closeOverlay, child: const Text('closeInAppMessage()')),
                const SizedBox(height: 8),
                ElevatedButton(
                    onPressed: _sendExpressionFailEvent,
                    child: const Text('Send expression-fail event')),
                if (expressionVerdict != null) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(expressionVerdict, style: const TextStyle(fontSize: 13)),
                ],
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
