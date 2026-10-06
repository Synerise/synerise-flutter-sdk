import 'package:flutter/material.dart';

import 'inline_single_screen.dart';
import 'inline_same_key_screen.dart';
import 'inline_on_demand_screen.dart';
import 'inline_two_keys_screen.dart';
import 'inline_priority_screen.dart';
import 'inline_global_listener_screen.dart';
import 'inline_dynamic_screen.dart';
import 'inline_two_global_events_screen.dart';
import 'inline_edge_cases_screen.dart';
import 'inline_config_screen.dart';
import 'inline_auto_resize_screen.dart';
import 'inline_debug_screen.dart';
import 'inline_lifecycle_screen.dart';
import 'inline_reattach_screen.dart';
import 'inline_search_host_screen.dart';
import 'inline_rotation_screen.dart';
import 'inline_verification_screen.dart';
import 'inline_default_link_handling_screen.dart';
import 'inline_prerender_reveal_screen.dart';
import 'inline_is_rendered_screen.dart';
import 'inline_unadopted_view_screen.dart';

class InlineInAppSectionScreen extends StatelessWidget {
  const InlineInAppSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_Scenario> scenarios = <_Scenario>[
      _Scenario('Single Placement', () => const InlineSingleScreen()),
      _Scenario('Same Key', () => const InlineSameKeyScreen()),
      _Scenario('On Demand', () => const InlineOnDemandScreen()),
      _Scenario('Two Keys', () => const InlineTwoKeysScreen()),
      _Scenario('Priority', () => const InlinePriorityScreen()),
      _Scenario('Global Listener', () => const InlineGlobalListenerScreen()),
      _Scenario('Dynamic (render)', () => const InlineDynamicScreen()),
      _Scenario('Two Global Events', () => const InlineTwoGlobalEventsScreen()),
      _Scenario('Edge Cases', () => const InlineEdgeCasesScreen()),
      _Scenario('Config', () => const InlineConfigScreen()),
      _Scenario('Auto Resize', () => const InlineAutoResizeScreen()),
      _Scenario('Debug', () => const InlineDebugScreen()),
      _Scenario('Lifecycle', () => const InlineLifecycleScreen()),
      _Scenario('Reattach', () => const InlineReattachScreen()),
      _Scenario('Search', () => const InlineSearchHostScreen()),
      _Scenario('Rotation', () => const InlineRotationScreen()),
      _Scenario('Verification', () => const InlineVerificationScreen()),
      _Scenario('Verification ×3 queued', () => const InlineVerificationScreen(queuedRenderCount: 3)),
      _Scenario('Default Link Handling', () => const InlineDefaultLinkHandlingScreen()),
      _Scenario('Pre-render hidden → reveal', () => const InlinePrerenderRevealScreen()),
      _Scenario('isRendered', () => const InlineIsRenderedScreen()),
      _Scenario('Unadopted View', () => const InlineUnadoptedViewScreen()),
      _Scenario('Unadopted View (priority)',
          () => const InlineUnadoptedViewScreen(
              placementKey: 'priority',
              triggerEvent: 'inline.priority',
              secondCampaignEvent: 'inline.priorityhigh')),
      _Scenario('Unadopted View (two placements)',
          () => const InlineUnadoptedViewScreen(
              placementKey: 'priority',
              triggerEvent: 'inline.priority',
              secondCampaignEvent: 'inline.global')),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Inline InApp')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: scenarios.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final _Scenario scenario = scenarios[index];
          return ListTile(
            title: Text(scenario.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => scenario.build()),
            ),
          );
        },
      ),
    );
  }
}

class _Scenario {
  final String label;
  final Widget Function() build;

  _Scenario(this.label, this.build);
}
