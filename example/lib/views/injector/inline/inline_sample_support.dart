import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

export '../sample_log.dart';

import '../sample_log.dart';

/// Registers the global inline in-app listener used by every demo screen. With [groupTag] set, all
/// callbacks log under that single tag (e.g. "GLOBAL"); otherwise each logs under its own name.
void registerInlineListener({
  required LogCallback log,
  String? groupTag,
  void Function(InlineInAppView view, InlineInAppMessageData data)? onAvailable,
}) {
  Synerise.injector.inlineInAppMessageListener((listener) {
    listener.onInlineInAppAvailable = (view, data) {
      groupTag != null
          ? log(groupTag, 'onInlineInAppAvailable hash=${data.campaignHash} key=${data.placementKey}')
          : log('onInlineInAppAvailable', 'hash=${data.campaignHash}');
      onAvailable?.call(view, data);
    };
    listener.onOpenUrl = (data, url) => groupTag != null
        ? log(groupTag, 'onOpenedUrl: $url')
        : log('onOpenedUrl', url);
    listener.onDeepLink = (data, deepLink) => groupTag != null
        ? log(groupTag, 'onOpenedDeepLink: $deepLink')
        : log('onOpenedDeepLink', deepLink);
    listener.onCustomAction = (data, name, parameters) => groupTag != null
        ? log(groupTag, 'onCustomAction: $name')
        : log('onCustomAction', '$name params=$parameters');
    listener.onCustomMethod = (data, name, parameters, completion) {
      groupTag != null
          ? log(groupTag, 'onCustomMethod: $name')
          : log('onCustomMethod', '$name params=$parameters');
      completion.success(parameters);
    };
  });
}

/// An `InlineInAppView` whose per-view callbacks log under their own callback names.
InlineInAppView buildInlineView({
  required String placementKey,
  required LogCallback log,
  InlineInAppViewController? controller,
  void Function(InlineInAppMessageData data, InlineInAppSize size)? onSizeChanged,
  String? adoptViewId,
  void Function(InlineInAppMessageData data)? onRemove,
  void Function(InlineInAppMessageData data)? onLoaded,
}) {
  return InlineInAppView(
    placementKey: placementKey,
    adoptViewId: adoptViewId,
    controller: controller,
    onProcessingStarted: () => log('onProcessingStarted', ''),
    onLoaded: onLoaded ?? (data) => log('onLoaded', 'hash=${data.campaignHash}'),
    onUpdated: (data) => log('onUpdated', 'hash=${data.campaignHash}'),
    onFailed: (data, error) => log('onFailed', error),
    onRemove: onRemove ?? (data) => log('onRemove', 'hash=${data.campaignHash}'),
    onSizeChanged:
        onSizeChanged ?? (data, size) => log('onSizeChanged', 'w=${size.width} h=${size.height}'),
  );
}

/// An `InlineInAppView` whose per-view callbacks log under a fixed component [tag]
/// (for screens that host several inline views).
InlineInAppView buildTaggedInlineView({
  required String placementKey,
  required String tag,
  required LogCallback log,
  InlineInAppViewController? controller,
}) {
  return InlineInAppView(
    placementKey: placementKey,
    controller: controller,
    onProcessingStarted: () => log('onProcessingStarted', ''),
    onLoaded: (data) => log(tag, 'onLoaded hash=${data.campaignHash}'),
    onUpdated: (data) => log(tag, 'onUpdated hash=${data.campaignHash}'),
    onFailed: (data, error) => log(tag, 'onFailed: $error'),
    onRemove: (data) => log(tag, 'onRemove'),
    onSizeChanged: (data, size) => log(tag, 'onSizeChanged w=${size.width} h=${size.height}'),
  );
}

/// One campaign the SDK announced through the global listener, together with the widget that
/// mounts the SDK-rendered view (an `InlineInAppView` carrying the announced `adoptViewId`).
class AnnouncedCampaign {
  final String placementKey;
  final String campaignHash;
  final Widget view;

  const AnnouncedCampaign({
    required this.placementKey,
    required this.campaignHash,
    required this.view,
  });
}

/// Bookkeeping for the "Two Global Events" screen: one entry per placement key (a newer campaign on
/// the same key replaces the older one, mirroring the RN sample) plus the parity check shown on
/// screen, which passes only when every announcement arrived with its own key and campaign hash.
class AnnouncedCampaigns {
  final List<AnnouncedCampaign> _entries = <AnnouncedCampaign>[];

  List<AnnouncedCampaign> get entries => List<AnnouncedCampaign>.unmodifiable(_entries);

  int get length => _entries.length;

  int get distinctKeys => _entries.map((entry) => entry.placementKey).toSet().length;

  int get distinctHashes => _entries.map((entry) => entry.campaignHash).toSet().length;

  void add(AnnouncedCampaign entry) {
    _entries.removeWhere((existing) => existing.placementKey == entry.placementKey);
    _entries.add(entry);
  }

  void clear() => _entries.clear();

  String get verdict {
    if (length < 2) {
      return 'check: send both events';
    }
    return distinctKeys == length && distinctHashes == length
        ? 'check: PASS — each event announced its own campaign'
        : 'check: FAIL — announcements collided';
  }
}
