import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Mirror of the RN/Android sample's "Edge Cases" screen: a "nomatch" placement (no campaign),
/// an "edgeempty" placement (empty HTML), and a swap placement toggling between "edgeswap"/"single".
class InlineEdgeCasesScreen extends StatefulWidget {
  const InlineEdgeCasesScreen({super.key});

  @override
  State<InlineEdgeCasesScreen> createState() => _InlineEdgeCasesScreenState();
}

class _InlineEdgeCasesScreenState extends State<InlineEdgeCasesScreen>
    with InlineSampleLog<InlineEdgeCasesScreen> {
  static const String _keyNoMatch = 'nomatch';
  static const String _keyEmpty = 'edgeempty';
  static const String _keySwap = 'edgeswap';
  static const String _keySwapAlternate = 'single';

  String _swapKey = _keySwap;

  @override
  void initState() {
    super.initState();
    appendLog('NoMatch', 'created with key=$_keyNoMatch');
    appendLog('Empty', 'created with key=$_keyEmpty');
    appendLog('Swap', 'created with key=$_keySwap');
    registerInlineListener(log: appendLog, groupTag: 'GLOBAL');
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  void _swapPlacementKey() {
    if (_swapKey == _keySwap) {
      appendLog('action', 'swapping key to: $_keySwapAlternate');
      setState(() => _swapKey = _keySwapAlternate);
    } else {
      appendLog('action', 'swapping key back to: $_keySwap');
      setState(() => _swapKey = _keySwap);
    }
  }

  Widget _view(String tag, String placementKey) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: buildTaggedInlineView(placementKey: placementKey, tag: tag, log: appendLog),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text(text, style: const TextStyle(fontSize: 13)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edge Cases')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _label('No match (key $_keyNoMatch)'),
                  _view('NoMatch', _keyNoMatch),
                  _label('Empty HTML (key $_keyEmpty)'),
                  _view('Empty', _keyEmpty),
                  _label('Swap (current key $_swapKey)'),
                  _view('Swap', _swapKey),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: ElevatedButton(onPressed: _swapPlacementKey, child: const Text('swap key')),
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
