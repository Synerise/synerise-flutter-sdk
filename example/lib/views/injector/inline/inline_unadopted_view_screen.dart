import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Answers one question the other screens cannot: when an event resolves a campaign for a placement
/// that has no InlineInAppView on screen, the SDK builds the view itself and hands it over through
/// onInlineInAppAvailable — so is an impression counted for a view the app never displays?
///
/// It matters because Flutter can only show that view through a wrapping platform view. Until the
/// app mounts it with adoptViewId the view is detached, and the native side defers `inApp.show` to
/// onAttachedToWindow. This screen makes the app's decision explicit so the deferral can be checked
/// against the tracker: adopt at once, adopt late, or never adopt at all.
class InlineUnadoptedViewScreen extends StatefulWidget {
  /// The placement whose campaign no mounted view claims, so the global listener is the only path.
  final String placementKey;

  /// The event that resolves the campaign. Pointing two entries at different placements lets the
  /// same screen probe accounts whose campaigns are spread differently.
  final String triggerEvent;

  /// A second event, sent after the first announcement was dropped. Point it at another campaign on
  /// the same placement to ask whether the un-adopted view blocks that placement, or at a campaign
  /// on a different placement to ask whether the damage is scoped to one key.
  final String? secondCampaignEvent;

  const InlineUnadoptedViewScreen({
    super.key,
    this.placementKey = 'globalonly',
    this.triggerEvent = 'inline.global',
    this.secondCampaignEvent,
  });

  @override
  State<InlineUnadoptedViewScreen> createState() => _InlineUnadoptedViewScreenState();
}

enum _AdoptionPolicy {
  adoptImmediately('adopt as soon as announced'),
  adoptAfterDelay('adopt 15 s after announcement'),
  neverAdopt('never adopt — drop the view');

  final String label;

  const _AdoptionPolicy(this.label);
}

class _InlineUnadoptedViewScreenState extends State<InlineUnadoptedViewScreen>
    with InlineSampleLog<InlineUnadoptedViewScreen> {
  static const Duration _lateAdoptionDelay = Duration(seconds: 15);

  _AdoptionPolicy _policy = _AdoptionPolicy.neverAdopt;
  InlineInAppView? _adoptedView;
  Timer? _lateAdoptionTimer;

  int _announcedCount = 0;
  int _adoptedCount = 0;
  DateTime? _announcedAt;
  Duration? _announcementToAdoption;

  @override
  void initState() {
    super.initState();
    appendLog('init',
        'no view mounted for key=${widget.placementKey} — global listener is the only path');
    appendLog('init', 'policy=${_policy.label}');
    registerInlineListener(
      log: appendLog,
      groupTag: 'GLOBAL',
      onAvailable: _onInlineInAppAvailable,
    );
  }

  @override
  void dispose() {
    _lateAdoptionTimer?.cancel();
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  void _onInlineInAppAvailable(InlineInAppView view, InlineInAppMessageData data) {
    if (!mounted) {
      return;
    }
    setState(() {
      _announcedCount++;
      _announcedAt = DateTime.now();
    });
    appendLog('announce', 'viewId=${view.adoptViewId} hash=${data.campaignHash} — '
        'view exists natively but is NOT in the widget tree yet');

    switch (_policy) {
      case _AdoptionPolicy.adoptImmediately:
        _adopt(view, data);
        break;
      case _AdoptionPolicy.adoptAfterDelay:
        appendLog('policy', 'holding the view unadopted for ${_lateAdoptionDelay.inSeconds} s — '
            'any inApp.show before adoption would be an impression nobody saw');
        _lateAdoptionTimer?.cancel();
        _lateAdoptionTimer = Timer(_lateAdoptionDelay, () => _adopt(view, data));
        break;
      case _AdoptionPolicy.neverAdopt:
        appendLog('policy', 'dropping the view — it stays retained natively and never reaches '
            'the widget tree');
        break;
    }
  }

  void _adopt(InlineInAppView view, InlineInAppMessageData data) {
    if (!mounted) {
      return;
    }
    final DateTime? announcedAt = _announcedAt;
    setState(() {
      _adoptedCount++;
      _announcementToAdoption =
          announcedAt == null ? null : DateTime.now().difference(announcedAt);
      _adoptedView = buildInlineView(
        placementKey: data.placementKey,
        adoptViewId: view.adoptViewId,
        log: appendLog,
      );
    });
    appendLog('adopt', 'mounted viewId=${view.adoptViewId} '
        '${_announcementToAdoption == null ? '' : '+${_announcementToAdoption!.inMilliseconds}ms '
            'after announcement'}');
  }

  void _sendTriggerEvent() {
    _sendEvent(widget.triggerEvent);
  }

  void _sendSecondCampaignEvent() {
    final String? event = widget.secondCampaignEvent;
    if (event == null) {
      return;
    }
    appendLog('action', 'announcements so far: $_announcedCount — a new announcement here means '
        'a fresh campaign still reaches the app');
    _sendEvent(event);
  }

  void _sendEvent(String action) {
    appendLog('action', 'sending event: $action');
    Synerise.tracker.send(CustomEvent('Unadopted view trigger', action, null));
  }

  void _selectPolicy(_AdoptionPolicy policy) {
    _lateAdoptionTimer?.cancel();
    setState(() {
      _policy = policy;
      _adoptedView = null;
      _announcementToAdoption = null;
    });
    appendLog('policy', 'policy=${policy.label}');
  }

  String get _verdict {
    if (_announcedCount == 0) {
      return 'pick a policy, then send the event';
    }
    if (_policy == _AdoptionPolicy.neverAdopt) {
      return 'announced $_announcedCount× · adopted 0× — now check the tracker: '
          'an inApp.show here would be an impression for a view never shown';
    }
    if (_adoptedCount == 0) {
      return 'announced $_announcedCount× · not adopted yet — inApp.show must not have been sent';
    }
    return 'announced $_announcedCount× · adopted $_adoptedCount× '
        '${_announcementToAdoption == null ? '' : '(+${_announcementToAdoption!.inMilliseconds}ms)'} '
        '— inApp.show is expected at adoption, not at announcement';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unadopted View')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'The event resolves a campaign for a placement with no view on screen. The SDK '
                  'builds the view and announces it; this screen decides whether it ever reaches '
                  'the widget tree. Watch inApp.show in the SDK log: it must follow adoption, not '
                  'the announcement.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                Text(_verdict, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                for (final _AdoptionPolicy policy in _AdoptionPolicy.values)
                  RadioListTile<_AdoptionPolicy>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: policy,
                    groupValue: _policy,
                    title: Text(policy.label, style: const TextStyle(fontSize: 13)),
                    onChanged: (selected) => selected == null ? null : _selectPolicy(selected),
                  ),
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: _sendTriggerEvent,
                  child: Text('send ${widget.triggerEvent}'),
                ),
                if (widget.secondCampaignEvent != null) ...<Widget>[
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: _sendSecondCampaignEvent,
                    child: Text('send ${widget.secondCampaignEvent}'),
                  ),
                ],
                const SizedBox(height: 10),
                if (_adoptedView != null)
                  SizedBox(height: 200, child: _adoptedView)
                else
                  Container(
                    height: 60,
                    alignment: Alignment.center,
                    color: Colors.black12,
                    child: const Text('no view in the widget tree',
                        style: TextStyle(fontSize: 12)),
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
