import 'package:flutter/material.dart';

import 'overlay_basic_screen.dart';
import 'in_app_url_deeplink_actions_screen.dart';
import 'overlay_capping_screen.dart';
import 'overlay_rotation_screen.dart';
import '../in_app_context_view.dart';
import 'in_app_storage_sharing_screen.dart';

/// Mirror of the RN sample's "Overlay" section (InAppSectionScreen): the overlay in-app test screens.
class OverlaySectionScreen extends StatelessWidget {
  const OverlaySectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_Scenario> scenarios = <_Scenario>[
      _Scenario('Overlay Basic', () => const OverlayBasicScreen()),
      _Scenario('URL & Deeplink Actions', () => const InAppUrlDeeplinkActionsScreen()),
      _Scenario('Overlay Capping', () => const OverlayCappingScreen()),
      _Scenario('Overlay Rotation', () => const OverlayRotationScreen()),
      _Scenario('InApp Context', () => const InAppContextView()),
      _Scenario('Storage Sharing', () => const InAppStorageSharingScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Overlay InApp')),
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
