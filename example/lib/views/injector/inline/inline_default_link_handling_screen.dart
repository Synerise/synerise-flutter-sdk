import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Third tier of the inline link chain: no inline listener claims the link, so it falls through to the
/// injector listener, which delegates straight to the SDK. The app being sent to the background is the
/// only evidence — nothing reports it as a callback.
///
/// The listener registered here mirrors `InjectorImpl.beforeInitialization`, which installs exactly
/// this delegation by default. It has to be set explicitly because `main.dart` overwrites that default
/// with one that only shows an alert, and `Synerise.injector.listener` mutates a single shared
/// instance with no way to restore it.
///
/// Mirrors the React Native sample's "Default Link Handling" screen.
class InlineDefaultLinkHandlingScreen extends StatefulWidget {
  const InlineDefaultLinkHandlingScreen({super.key});

  @override
  State<InlineDefaultLinkHandlingScreen> createState() => _InlineDefaultLinkHandlingScreenState();
}

class _InlineDefaultLinkHandlingScreenState extends State<InlineDefaultLinkHandlingScreen>
    with WidgetsBindingObserver {
  static const String _placementKey = 'demand';

  final InlineInAppViewController _controller = InlineInAppViewController();
  final List<String> _log = <String>[];

  bool _isCreativeLoaded = false;
  int _backgroundTransitionCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    appendLog('init', 'no inline listener registered — links must fall through to the SDK');
    Synerise.injector.listener((listener) {
      listener.onOpenUrl = (url, source) {
        appendLog('INJECTOR onOpenUrl', 'source=${source.syneriseSource} → handleOpenUrlBySDK');
        Synerise.injector.handleOpenUrlBySDK(url);
      };
      listener.onDeepLink = (deepLink, source) {
        appendLog('INJECTOR onDeepLink', 'source=${source.syneriseSource} → handleDeepLinkBySDK');
        Synerise.injector.handleDeepLinkBySDK(deepLink);
      };
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appendLog('appState', state.name);
    if (state == AppLifecycleState.paused) {
      setState(() => _backgroundTransitionCount++);
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

  void _render() {
    appendLog('action', 'render() called');
    _controller.render();
  }

  String get _verdict {
    if (!_isCreativeLoaded) {
      return 'tier 3: press render(), then tap "Open URL" inside the creative';
    }
    if (_backgroundTransitionCount == 0) {
      return 'tier 3: tap "Open URL" inside the creative — the SDK must open it';
    }
    return 'tier 3: PASS — handleOpenUrlBySDK opened the target (backgrounded '
        '$_backgroundTransitionCount×), with no inline listener involved';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Default Link Handling')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Open this screen on a FRESH APP LAUNCH. Synerise.injector.listener mutates one shared '
              'instance and cannot be removed, so any screen visited earlier keeps its listener for the '
              'rest of the session.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'No inline listener is registered here. The link falls through to the injector listener, '
              'which delegates to handleOpenUrlBySDK — so the app going to the background is the evidence.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text('creative loaded: ${_isCreativeLoaded ? 'yes' : 'no'} · backgrounded: '
                '$_backgroundTransitionCount×', style: const TextStyle(fontSize: 13)),
            Text(_verdict, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: buildInlineView(
                placementKey: _placementKey,
                controller: _controller,
                log: (tag, message) {
                  if (tag == 'onLoaded') {
                    _isCreativeLoaded = true;
                  }
                  appendLog(tag, message);
                },
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _render, child: const Text('render()')),
            const SizedBox(height: 14),
            const Text('Callback Log:', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 4),
            Text(_log.join('\n'), style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
