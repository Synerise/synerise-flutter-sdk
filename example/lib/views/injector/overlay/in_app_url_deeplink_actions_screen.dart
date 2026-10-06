import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'overlay_sample_support.dart';

/// Mirror of the RN sample's "URL & Deeplink Actions" screen: a link-action routing matrix. Two
/// independent switches decide whether the in-app listeners claim the link and what the injector
/// listener does with it, so every registration combination is observable. Overlay uses campaign 31
/// (event "overlay.urlactions"); inline reuses campaign 5 ("demand").
///
/// The SDK's own opener is never reached from Flutter: the bridge always holds a native injector
/// listener, so the target opens only when the app delegates through handleOpenUrlBySDK /
/// handleDeepLinkBySDK. Leaving the screen keeps the injector listener in its last mode until the app
/// restarts (the Home alert listener is overridden), exactly as in the RN sample.
class InAppUrlDeeplinkActionsScreen extends StatefulWidget {
  const InAppUrlDeeplinkActionsScreen({super.key});

  @override
  State<InAppUrlDeeplinkActionsScreen> createState() => _InAppUrlDeeplinkActionsScreenState();
}

class _InAppUrlDeeplinkActionsScreenState extends State<InAppUrlDeeplinkActionsScreen>
    with InlineSampleLog<InAppUrlDeeplinkActionsScreen> {
  static const String _overlayEventAction = 'overlay.urlactions';
  static const String _inlinePlacementKey = 'demand';
  static const double _containerHeight = 260;
  static const double _logHeight = 240;

  final LinkRoutingModes _modes = LinkRoutingModes();
  final InlineInAppViewController _inlineController = InlineInAppViewController();

  @override
  void initState() {
    super.initState();
    _applyModes();
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  /// Re-registers all three listeners for the current switch positions and logs the expectation.
  /// Every callback field is assigned (null when the mode omits it) — see setOverlayListener.
  void _applyModes() {
    _registerInjectorListener();
    final bool claimsLinks = _modes.inAppListenerMode == InAppListenerMode.claimsLinks;

    setOverlayListener(
      onPresent: (data) => appendLog('overlay onPresent', 'hash=${data.campaignHash}'),
      onHide: (data) => appendLog('overlay onHide', 'hash=${data.campaignHash}'),
      onOpenUrl: claimsLinks ? (data, url) => appendLog('overlay onOpenUrl', url) : null,
      onDeepLink:
          claimsLinks ? (data, deepLink) => appendLog('overlay onDeepLink', deepLink) : null,
      onCustomAction: claimsLinks
          ? (data, name, parameters) => appendLog('overlay onCustomAction', name)
          : null,
    );

    Synerise.injector.inlineInAppMessageListener((listener) {
      listener.onInlineInAppAvailable =
          (view, data) => appendLog('inline available', 'hash=${data.campaignHash}');
      listener.onOpenUrl = claimsLinks ? (data, url) => appendLog('inline onOpenUrl', url) : null;
      listener.onDeepLink =
          claimsLinks ? (data, deepLink) => appendLog('inline onDeepLink', deepLink) : null;
      listener.onCustomAction =
          claimsLinks ? (data, name, parameters) => appendLog('inline onCustomAction', name) : null;
      listener.onCustomMethod = claimsLinks
          ? (data, name, parameters, completion) {
              appendLog('inline onCustomMethod', name);
              completion.success(parameters);
            }
          : null;
    });

    appendLog('mode', _modes.inAppListenerLabel);
    appendLog('mode', _modes.injectorListenerLabel);
    appendLog('expect', _modes.expectation);
  }

  void _registerInjectorListener() {
    Synerise.injector.listener((listener) {
      listener.onOpenUrl = (url, source) {
        appendLog('INJECTOR onOpenUrl', 'source=${source.syneriseSource} url=$url');
        if (_modes.injectorListenerMode == InjectorListenerMode.delegatesToSdk) {
          appendLog('INJECTOR', 'delegating: handleOpenUrlBySDK');
          Synerise.injector.handleOpenUrlBySDK(url);
        }
      };
      listener.onDeepLink = (deepLink, source) {
        appendLog('INJECTOR onDeepLink', 'source=${source.syneriseSource} deepLink=$deepLink');
        if (_modes.injectorListenerMode == InjectorListenerMode.delegatesToSdk) {
          appendLog('INJECTOR', 'delegating: handleDeepLinkBySDK');
          Synerise.injector.handleDeepLinkBySDK(deepLink);
        }
      };
    });
  }

  void _triggerOverlay() {
    appendLog('action', 'sending EVENT: $_overlayEventAction');
    Synerise.tracker.send(CustomEvent('Overlay url actions', _overlayEventAction, null));
  }

  void _renderInline() {
    appendLog('action', 'inline render() called');
    _inlineController.render();
  }

  void _switchInAppListenerMode() {
    setState(() => _modes.toggleInAppListenerMode());
    _applyModes();
  }

  void _switchInjectorListenerMode() {
    setState(() => _modes.toggleInjectorListenerMode());
    _applyModes();
  }

  Widget _heading(String text) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('URL & Deeplink Actions')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _heading('Routing matrix'),
                  Text(_modes.inAppListenerLabel, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(_modes.injectorListenerLabel, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('expect: ${_modes.expectation}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: _switchInAppListenerMode,
                      child: const Text('Switch in-app listeners')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: _switchInjectorListenerMode,
                      child: const Text('Switch injector listener')),
                  _heading('Overlay'),
                  ElevatedButton(
                      onPressed: _triggerOverlay,
                      child: const Text('Trigger overlay (url actions)')),
                  _heading('Inline — $_inlinePlacementKey'),
                  SizedBox(
                    height: _containerHeight,
                    child: InlineInAppView(
                      placementKey: _inlinePlacementKey,
                      controller: _inlineController,
                      onLoaded: (data) => appendLog('inline onLoaded', 'hash=${data.campaignHash}'),
                      onFailed: (data, error) => appendLog('inline onFailed', error),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: _renderInline, child: const Text('render() inline')),
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
