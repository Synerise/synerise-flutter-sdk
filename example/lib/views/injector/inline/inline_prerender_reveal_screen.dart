import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'inline_sample_support.dart';

/// How the inline view is kept out of sight while the campaign renders into it. Each strategy treats the
/// underlying platform view differently, which decides whether render() can start at all and when the
/// SDK counts the impression (watch `inApp.show` in the native log).
enum HidingStrategy {
  zeroHeight('SizedBox height 0 → 300', 'view stays in the tree with zero height; needs the Android creation-size fix'),
  offstage('Offstage', 'laid out at full size but not painted and takes no space'),
  invisible('Opacity 0 + IgnorePointer', 'painted transparent, takes its full space');

  const HidingStrategy(this.label, this.description);

  final String label;
  final String description;
}

/// Renders an ON_DEMAND campaign into an inline view the user cannot see, then reveals the already
/// rendered content on a button tap — the "preload, then show" pattern — under three hiding strategies.
class InlinePrerenderRevealScreen extends StatefulWidget {
  const InlinePrerenderRevealScreen({super.key});

  @override
  State<InlinePrerenderRevealScreen> createState() => _InlinePrerenderRevealScreenState();
}

class _InlinePrerenderRevealScreenState extends State<InlinePrerenderRevealScreen>
    with InlineSampleLog<InlinePrerenderRevealScreen> {
  static const String _placementKey = 'demand';
  static const double _revealedHeight = 300;

  HidingStrategy _strategy = HidingStrategy.zeroHeight;
  bool _hidden = true;
  int _viewGeneration = 0;
  InlineInAppViewController _controller = InlineInAppViewController();

  @override
  void initState() {
    super.initState();
    appendLog('init', 'key=$_placementKey hidden=true strategy=${_strategy.name}');
    registerInlineListener(log: appendLog);
  }

  @override
  void dispose() {
    Synerise.injector.removeInlineInAppListener();
    super.dispose();
  }

  void _selectStrategy(HidingStrategy strategy) {
    setState(() {
      _strategy = strategy;
      _resetViewState();
    });
    appendLog('action', 'strategy=${strategy.name} — view recreated, hidden=true');
  }

  void _resetView() {
    setState(_resetViewState);
    appendLog('action', 'reset — fresh view, hidden=true');
  }

  void _resetViewState() {
    _hidden = true;
    _viewGeneration++;
    _controller = InlineInAppViewController();
  }

  void _renderWhileHidden() {
    appendLog('action', 'render() called while hidden=$_hidden (${_strategy.name}) — watch inApp.show in the SDK log');
    _controller.render();
  }

  void _setHidden(bool hidden) {
    setState(() => _hidden = hidden);
    appendLog('action', hidden ? 'hide — no re-render expected' : 'SHOW — expect content without a new onLoaded');
  }

  Widget _buildHostedView() {
    final Widget view = KeyedSubtree(
      key: ValueKey<int>(_viewGeneration),
      child: buildInlineView(placementKey: _placementKey, controller: _controller, log: appendLog),
    );
    switch (_strategy) {
      case HidingStrategy.zeroHeight:
        return SizedBox(height: _hidden ? 0 : _revealedHeight, child: view);
      case HidingStrategy.offstage:
        return Offstage(offstage: _hidden, child: SizedBox(height: _revealedHeight, child: view));
      case HidingStrategy.invisible:
        return IgnorePointer(
          ignoring: _hidden,
          child: Opacity(opacity: _hidden ? 0 : 1, child: SizedBox(height: _revealedHeight, child: view)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pre-render hidden → reveal')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Placement: $_placementKey · hidden: $_hidden · ${_strategy.description}',
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: HidingStrategy.values
                      .map((strategy) => ChoiceChip(
                            label: Text(strategy.label),
                            selected: _strategy == strategy,
                            onSelected: (_) => _selectStrategy(strategy),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: _buildHostedView(),
                ),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _renderWhileHidden, child: const Text('render() while hidden')),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(child: ElevatedButton(onPressed: () => _setHidden(false), child: const Text('show'))),
                    const SizedBox(width: 8),
                    Expanded(child: ElevatedButton(onPressed: () => _setHidden(true), child: const Text('hide'))),
                    const SizedBox(width: 8),
                    Expanded(child: OutlinedButton(onPressed: _resetView, child: const Text('reset view'))),
                  ],
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
