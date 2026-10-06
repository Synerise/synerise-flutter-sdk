import 'package:flutter/material.dart';

typedef LogCallback = void Function(String tag, String message);

/// Shared on-screen callback log for the in-app demo screens (inline and overlay). Mirrors the RN
/// samples' timestamped `[tag] message` log that auto-scrolls to the newest line.
mixin InlineSampleLog<T extends StatefulWidget> on State<T> {
  final ScrollController logScrollController = ScrollController();
  final List<String> logLines = <String>[];

  void appendLog(String tag, String message) {
    final DateTime now = DateTime.now();
    final String time = '${_pad(now.hour, 2)}:${_pad(now.minute, 2)}:'
        '${_pad(now.second, 2)}.${_pad(now.millisecond, 3)}';
    final String line = message.isEmpty ? '$time [$tag]' : '$time [$tag] $message';
    if (!mounted) {
      logLines.add(line);
      return;
    }
    setState(() => logLines.add(line));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (logScrollController.hasClients) {
        logScrollController.jumpTo(logScrollController.position.maxScrollExtent);
      }
    });
  }

  String _pad(int value, int width) => value.toString().padLeft(width, '0');

  Widget get callbackLogLabel => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Text('Callback Log:', style: TextStyle(fontSize: 13)),
      );

  Widget buildLogScroll() {
    return SingleChildScrollView(
      controller: logScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        logLines.join('\n'),
        style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
      ),
    );
  }

  @override
  void dispose() {
    logScrollController.dispose();
    super.dispose();
  }
}
