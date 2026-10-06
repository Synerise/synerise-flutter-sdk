import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// Probes isRendered() at every lifecycle stage and checks it against getData(), because the two
/// answer the same question through different channels and a disagreement means one of them lies.
///
/// The stages that matter are the ones the other screens never pause on: the window between
/// render() and onLoaded, where the campaign is resolving but nothing is on screen yet, and the
/// window after release(), where the widget stays mounted but holds no campaign.
class InlineIsRenderedScreen extends StatefulWidget {
  const InlineIsRenderedScreen({super.key});

  @override
  State<InlineIsRenderedScreen> createState() => _InlineIsRenderedScreenState();
}

class _InlineIsRenderedScreenState extends State<InlineIsRenderedScreen>
    with InlineSampleLog<InlineIsRenderedScreen> {
  /// ON_DEMAND, so the screen controls exactly when the campaign appears.
  static const String _placementKey = 'demand';

  final InlineInAppViewController _controller = InlineInAppViewController();
  final List<_IsRenderedProbe> _probes = <_IsRenderedProbe>[];

  @override
  void initState() {
    super.initState();
    appendLog('init', 'placement=$_placementKey — nothing rendered yet');
    WidgetsBinding.instance.addPostFrameCallback((_) => _probe('A · before render()', false));
  }

  Future<void> _probe(String stage, bool expectedRendered) async {
    final bool isRendered = await _controller.isRendered();
    final InlineInAppMessageData? data = await _controller.getData();
    final _IsRenderedProbe probe = _IsRenderedProbe(
      stage: stage,
      expectedRendered: expectedRendered,
      actualRendered: isRendered,
      campaignHash: data?.campaignHash,
    );
    if (!mounted) {
      return;
    }
    setState(() => _probes.add(probe));
    appendLog('probe', probe.logLine);
  }

  Future<void> _renderAndProbeWhileProcessing() async {
    appendLog('action', 'render() called');
    _controller.render();
    await _probe('B · right after render(), before onLoaded', false);
  }

  Future<void> _releaseAndProbe() async {
    appendLog('action', 'release() called — widget stays mounted');
    await _controller.release();
    await _probe('D · after release()', false);
  }

  void _onLoaded(InlineInAppMessageData data) {
    appendLog('onLoaded', 'hash=${data.campaignHash}');
    _probe('C · after onLoaded', true);
  }

  String get _verdict {
    if (_probes.isEmpty) {
      return 'run the stages in order: A is automatic, then B, C follows onLoaded, then D';
    }
    final List<_IsRenderedProbe> disagreeing =
        _probes.where((probe) => probe.disagreesWithGetData).toList();
    if (disagreeing.isNotEmpty) {
      return 'FAIL — isRendered() and getData() disagree at: '
          '${disagreeing.map((probe) => probe.stage).join(', ')}';
    }
    final List<_IsRenderedProbe> unexpected =
        _probes.where((probe) => !probe.matchesExpectation).toList();
    if (unexpected.isNotEmpty) {
      return 'FAIL — unexpected isRendered() at: '
          '${unexpected.map((probe) => probe.stage).join(', ')}';
    }
    return 'PASS so far — ${_probes.length} probe(s), every isRendered() matched '
        'both its expectation and getData()';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('isRendered')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'isRendered() must be false until a campaign is actually on screen and false '
                  'again after release(). getData() is the cross-check: whenever isRendered() is '
                  'true getData() must return a campaign, and whenever it is false getData() must '
                  'be null.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                Text(_verdict, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                for (final _IsRenderedProbe probe in _probes)
                  Text(probe.resultLine, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: buildInlineView(
                    placementKey: _placementKey,
                    controller: _controller,
                    log: appendLog,
                    onLoaded: _onLoaded,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _renderAndProbeWhileProcessing,
                  child: const Text('B · render() + probe while processing'),
                ),
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: _releaseAndProbe,
                  child: const Text('D · release() + probe'),
                ),
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () => _probe('manual probe', true),
                  child: const Text('probe now (expects rendered)'),
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

class _IsRenderedProbe {
  final String stage;
  final bool expectedRendered;
  final bool actualRendered;
  final String? campaignHash;

  const _IsRenderedProbe({
    required this.stage,
    required this.expectedRendered,
    required this.actualRendered,
    required this.campaignHash,
  });

  bool get matchesExpectation => actualRendered == expectedRendered;

  bool get disagreesWithGetData => actualRendered != (campaignHash != null);

  String get logLine =>
      '$stage → isRendered=$actualRendered getData=${campaignHash ?? 'null'} '
      '(expected isRendered=$expectedRendered)';

  String get resultLine {
    final String mark = disagreesWithGetData || !matchesExpectation ? '✗' : '✓';
    return '$mark $stage · isRendered=$actualRendered · getData=${campaignHash ?? 'null'}';
  }
}
