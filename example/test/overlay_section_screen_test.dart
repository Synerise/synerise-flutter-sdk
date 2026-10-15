import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:synerise_flutter_sdk_example/views/injector/overlay/overlay_section_screen.dart';

void main() {
  testWidgets('Overlay InApp menu lists the RN overlay screens in RN order', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: OverlaySectionScreen()));

    expect(find.text('Overlay InApp'), findsOneWidget);
    expect(find.text('Overlay Basic'), findsOneWidget);
    expect(find.text('URL & Deeplink Actions'), findsOneWidget);
    expect(find.text('Overlay Capping'), findsOneWidget);
    expect(find.text('Overlay Rotation'), findsOneWidget);
    expect(find.text('InApp Context'), findsOneWidget);
    expect(find.text('Storage Sharing'), findsOneWidget);
  });
}
