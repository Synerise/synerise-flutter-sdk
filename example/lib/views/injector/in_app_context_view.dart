// DEMO/SAMPLE screen for the app<->InApp context feature. Mirrors the React Native
// InAppContextScreen: seeds Injector.inAppContext, lets you add keys, push changes via
// notifyInAppContextChange(), and fire a trigger event. In-app message listener callbacks are
// logged on screen. Requires a configured in-app campaign that reads the context
// (SRInApp.getContextFromApp) and triggers on the "inapp.context.test" event.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

class InAppContextView extends StatefulWidget {
  const InAppContextView({super.key});

  @override
  State<InAppContextView> createState() => _InAppContextViewState();
}

class _InAppContextViewState extends State<InAppContextView> {
  final ScrollController _logScrollController = ScrollController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  String _log = '';
  String _contextText = '';

  @override
  void initState() {
    super.initState();

    _seedContext();

    Synerise.injector.inAppMessageListener((listener) {
      listener.onPresent = (data) => _appendLog('onPresent', data.campaignHash);
      listener.onHide = (data) => _appendLog('onHide', data.campaignHash);
      listener.onOpenUrl = (data, url) => _appendLog('onOpenUrl', url);
      listener.onDeepLink = (data, deepLink) => _appendLog('onDeepLink', deepLink);
      listener.onCustomAction = (data, name, parameters) =>
          _appendLog('onCustomAction', '$name params=${_stringify(parameters)}');
      listener.onCustomMethod = (data, name, parameters, completion) {
        _appendLog('onCustomMethod', '$name params=${_stringify(parameters)}');
        _handleCustomMethod(name, parameters, completion);
      };
    });

    _appendLog('init',
        'InApp listener registered. Trigger your campaign, then use the InApp.');
  }

  @override
  void dispose() {
    _logScrollController.dispose();
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _appendLog(String tag, String message) {
    if (!mounted) {
      return;
    }
    final now = DateTime.now();
    final time = now.toIso8601String().split('T').last;
    setState(() {
      _log += '$time [$tag] $message\n';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        _logScrollController.jumpTo(_logScrollController.position.maxScrollExtent);
      }
    });
  }

  String _stringify(Object? value) {
    try {
      return jsonEncode(value);
    } catch (_) {
      return value.toString();
    }
  }

  void _refreshContext() {
    if (!mounted) {
      return;
    }
    setState(() {
      _contextText = _stringify(Map<String, dynamic>.from(Synerise.injector.inAppContext));
    });
  }

  void _seedContext() {
    Synerise.injector.inAppContext.clear();
    Synerise.injector.inAppContext["userName"] = "Konrad";
    Synerise.injector.inAppContext["loyaltyTier"] = "gold";
    Synerise.injector.inAppContext["cartItems"] = 3;
    Synerise.injector.inAppContext["changeCount"] = 0;
    _refreshContext();
    _appendLog('seed', 'Context reset to defaults');
  }

  Object _parseValue(String raw) {
    final value = raw.trim();
    final lower = value.toLowerCase();
    if (lower == 'true' || lower == 'false') {
      return lower == 'true';
    }
    final asNumber = num.tryParse(value);
    if (value.isNotEmpty && asNumber != null) {
      return asNumber;
    }
    return value;
  }

  void _addToContext() {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      _appendLog('add', 'key is empty');
      return;
    }
    final value = _parseValue(_valueController.text);
    // Mutating the map syncs the change to the SDK immediately.
    Synerise.injector.inAppContext[key] = value;
    _refreshContext();
    _appendLog('add', 'put $key = ${_stringify(value)}');
    _valueController.clear();
  }

  void _notifyContextChange() {
    Synerise.injector.notifyInAppContextChange();
    _appendLog('notify', 'notifyInAppContextChange() called');
  }

  void _sendTriggerEvent() {
    Synerise.tracker.send(CustomEvent('InApp context test', 'inapp.context.test', null));
    _appendLog('event', 'Sent trigger event: inapp.context.test');
  }

  int _resolveSimulatedDelay(Map<String, dynamic> parameters) {
    final raw = parameters['delayMs'];
    final delay = raw is num ? raw.toInt() : 500;
    return delay.clamp(0, 15000);
  }

  void _handleCustomMethod(
      String name, Map<String, dynamic> parameters, InAppCustomMethodCompletion completion) {
    Future.delayed(Duration(milliseconds: _resolveSimulatedDelay(parameters)), () {
      if (name == 'failingMethod') {
        _appendLog('customMethod', '-> failure: simulated');
        completion.failure('Simulated failure from the app for: $name');
        return;
      }

      if (name == 'requestContextChange') {
        final current = Synerise.injector.inAppContext['changeCount'];
        final next = current is int ? current + 1 : 1;
        Synerise.injector.inAppContext['changeCount'] = next;
        Synerise.injector.inAppContext['loyaltyTier'] = next % 2 == 0 ? 'gold' : 'platinum';
        Synerise.injector.inAppContext['changedAt'] = DateTime.now().millisecondsSinceEpoch;
        Synerise.injector.notifyInAppContextChange();
        _refreshContext();
        _appendLog('customMethod', '-> context changed (#$next) and notified');
        completion.success({'status': 'context-updated', 'changeCount': next});
        return;
      }

      if (name == 'fetchUserPoints') {
        final result = {
          'userId': parameters['userId'],
          'points': 1280,
          'currency': 'PLN',
        };
        _appendLog('customMethod', '-> success: ${_stringify(result)}');
        completion.success(result);
        return;
      }

      _appendLog('customMethod', '-> echo');
      completion.success({'handled': name, 'params': parameters});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InApp Context & Custom Methods'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Current context:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(_contextText,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _keyController,
                          decoration: const InputDecoration(
                              labelText: 'key', border: OutlineInputBorder()),
                          textCapitalization: TextCapitalization.none,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _valueController,
                          decoration: const InputDecoration(
                              labelText: 'value', border: OutlineInputBorder()),
                          textCapitalization: TextCapitalization.none,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: _addToContext, child: const Text('Add to context')),
                  ElevatedButton(
                      onPressed: _notifyContextChange,
                      child: const Text('Notify context change')),
                  ElevatedButton(
                      onPressed: _seedContext, child: const Text('Reseed context')),
                  ElevatedButton(
                      onPressed: _sendTriggerEvent,
                      child: const Text('Send trigger event')),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Callback log:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCCCCCC)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(
                  controller: _logScrollController,
                  child: Text(_log,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
