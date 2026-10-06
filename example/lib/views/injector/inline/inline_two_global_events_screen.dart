import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN sample's "Two Global Events" screen: two EVENT-triggered inline campaigns on
/// different placement keys, both announced through the single global listener. Nothing is mounted
/// up front; each announcement must arrive with its own view and its own data, and mounting the
/// first must not disturb the second. Needs campaigns on placement "globalonly" (event
/// "inline.global") and a second placement (event "inline.globalsecond").
class InlineTwoGlobalEventsScreen extends StatefulWidget {
  const InlineTwoGlobalEventsScreen({super.key});

  @override
  State<InlineTwoGlobalEventsScreen> createState() => _InlineTwoGlobalEventsScreenState();
}

class _InlineTwoGlobalEventsScreenState extends State<InlineTwoGlobalEventsScreen>
    with InlineSampleLog<InlineTwoGlobalEventsScreen> {
  static const String _firstEventAction = 'inline.global';
  static const String _secondEventAction = 'inline.globalsecond';
  static const double _containerHeight = 220;

  final AnnouncedCampaigns _announced = AnnouncedCampaigns();

  @override
  void initState() {
    super.initState();
    appendLog('init', 'No views mounted. Global listener registered for both events.');
    registerInlineListener(
      log: appendLog,
      groupTag: 'GLOBAL',
      onAvailable: _onInlineInAppAvailable,
    );
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  void _onInlineInAppAvailable(InlineInAppView view, InlineInAppMessageData data) {
    appendLog('GLOBAL', 'available key=${data.placementKey} hash=${data.campaignHash}');
    setState(() => _announced.add(AnnouncedCampaign(
          placementKey: data.placementKey,
          campaignHash: data.campaignHash,
          view: buildInlineView(
            placementKey: data.placementKey,
            adoptViewId: view.adoptViewId,
            log: appendLog,
          ),
        )));
  }

  void _sendFirstEvent() {
    appendLog('action', 'sending EVENT: $_firstEventAction');
    Synerise.tracker.send(CustomEvent('Global listener first', _firstEventAction, null));
  }

  void _sendSecondEvent() {
    appendLog('action', 'sending EVENT: $_secondEventAction');
    Synerise.tracker.send(CustomEvent('Global listener second', _secondEventAction, null));
  }

  void _clearAnnounced() {
    setState(() => _announced.clear());
    appendLog('action', 'cleared mounted views');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Two Global Events')),
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
                    'Send both events. Each must arrive separately on the global listener with its '
                    'own placement key and campaign hash, and both views must render side by side.',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'announced: ${_announced.length} · distinct keys: ${_announced.distinctKeys} · '
                    'distinct campaigns: ${_announced.distinctHashes}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(_announced.verdict, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: _sendFirstEvent, child: const Text('Send $_firstEventAction')),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: _sendSecondEvent, child: const Text('Send $_secondEventAction')),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: _clearAnnounced, child: const Text('Clear mounted views')),
                  // Keyed by placement key so that mounting the second campaign does not remount
                  // (dispose → release()) the first one's platform view.
                  for (final AnnouncedCampaign entry in _announced.entries)
                    Column(
                      key: ValueKey<String>(entry.placementKey),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 8),
                        Text('${entry.placementKey} — ${entry.campaignHash}',
                            style: const TextStyle(fontSize: 13)),
                        const SizedBox(height: 4),
                        SizedBox(height: _containerHeight, child: entry.view),
                      ],
                    ),
                ],
              ),
            ),
            callbackLogLabel,
            SizedBox(height: _containerHeight, child: buildLogScroll()),
          ],
        ),
      ),
    );
  }
}
