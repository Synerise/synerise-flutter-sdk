import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "Two Keys" screen: an ON_DEMAND placement "inlinedemand"
/// (rendered via render()) and an EVENT placement "inlineevent", each with its own tagged listener.
class InlineTwoKeysScreen extends StatefulWidget {
  const InlineTwoKeysScreen({super.key});

  @override
  State<InlineTwoKeysScreen> createState() => _InlineTwoKeysScreenState();
}

class _InlineTwoKeysScreenState extends State<InlineTwoKeysScreen>
    with InlineSampleLog<InlineTwoKeysScreen> {
  static const String _keyOnDemand = 'inlinedemand';
  static const String _keyEvent = 'inlineevent';

  final InlineInAppViewController _onDemandController = InlineInAppViewController();

  @override
  void initState() {
    super.initState();
    appendLog('init', 'created ON_DEMAND view key=$_keyOnDemand');
    appendLog('init', 'created EVENT view key=$_keyEvent');
    registerInlineListener(log: appendLog, groupTag: 'GLOBAL');
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  void _render() {
    appendLog('action', 'render() called on $_keyOnDemand');
    _onDemandController.render();
  }

  void _sendTwoKeysEvent() {
    const String eventName = 'inline.two_keys';
    appendLog('action', 'sending event: $eventName');
    Synerise.tracker.send(CustomEvent('Inline two keys trigger', eventName, null));
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text(text, style: const TextStyle(fontSize: 13)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Two Keys')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _label('ON_DEMAND placement: $_keyOnDemand'),
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: buildTaggedInlineView(
                        placementKey: _keyOnDemand,
                        tag: 'OnDemand',
                        controller: _onDemandController,
                        log: appendLog),
                  ),
                  _label('EVENT placement: $_keyEvent'),
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: buildTaggedInlineView(
                        placementKey: _keyEvent, tag: 'Event', log: appendLog),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: ElevatedButton(
                        onPressed: _render, child: const Text('render() (inlinedemand)')),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: ElevatedButton(
                        onPressed: _sendTwoKeysEvent, child: const Text('send inline.two_keys')),
                  ),
                ],
              ),
            ),
          ),
          callbackLogLabel,
          SizedBox(height: 180, child: buildLogScroll()),
        ],
      ),
    );
  }
}
