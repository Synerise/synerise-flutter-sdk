import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "Config" screen: one section per placement key. ON_DEMAND keys
/// get a render() button; AUTOMATIC keys do not.
class InlineConfigScreen extends StatefulWidget {
  const InlineConfigScreen({super.key});

  @override
  State<InlineConfigScreen> createState() => _InlineConfigScreenState();
}

class _InlineConfigScreenState extends State<InlineConfigScreen>
    with InlineSampleLog<InlineConfigScreen> {
  static const List<String> _onDemandKeys = <String>[
    'cappinglife',
    'cappingtime',
    'controlgroup',
    'dynamic',
    'delaythree',
  ];
  static const List<String> _automaticKeys = <String>['schedulein', 'scheduleout'];

  final Map<String, InlineInAppViewController> _onDemandControllers =
      <String, InlineInAppViewController>{};

  @override
  void initState() {
    super.initState();
    for (final String key in _onDemandKeys) {
      _onDemandControllers[key] = InlineInAppViewController();
      appendLog(key, 'created');
    }
    for (final String key in _automaticKeys) {
      appendLog(key, 'created');
    }
    registerInlineListener(log: appendLog, groupTag: 'GLOBAL');
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  void _render(String key) {
    appendLog(key, 'render() called');
    _onDemandControllers[key]?.render();
  }

  Widget _section(String key, {required bool onDemand}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text('$key ${onDemand ? '(ON_DEMAND)' : '(AUTOMATIC)'}',
              style: const TextStyle(fontSize: 13)),
        ),
        Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: buildTaggedInlineView(
              placementKey: key,
              tag: key,
              controller: onDemand ? _onDemandControllers[key] : null,
              log: appendLog),
        ),
        if (onDemand)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: ElevatedButton(onPressed: () => _render(key), child: Text('render() $key')),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Config')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ..._onDemandKeys.map((key) => _section(key, onDemand: true)),
                  ..._automaticKeys.map((key) => _section(key, onDemand: false)),
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
