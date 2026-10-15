import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:synerise_flutter_sdk_example/views/injector/inline/inline_sample_support.dart';

AnnouncedCampaign _campaign(String placementKey, String campaignHash) {
  return AnnouncedCampaign(
    placementKey: placementKey,
    campaignHash: campaignHash,
    view: const SizedBox.shrink(),
  );
}

void main() {
  group('AnnouncedCampaigns', () {
    test('starts empty and asks for both events', () {
      final AnnouncedCampaigns campaigns = AnnouncedCampaigns();

      expect(campaigns.length, 0);
      expect(campaigns.distinctKeys, 0);
      expect(campaigns.distinctHashes, 0);
      expect(campaigns.verdict, 'check: send both events');
    });

    test('keeps one entry per placement key, newest wins', () {
      final AnnouncedCampaigns campaigns = AnnouncedCampaigns();

      campaigns.add(_campaign('globalonly', 'hash-1'));
      campaigns.add(_campaign('globalonly', 'hash-2'));

      expect(campaigns.length, 1);
      expect(campaigns.entries.single.campaignHash, 'hash-2');
      expect(campaigns.verdict, 'check: send both events');
    });

    test('passes when each event announced its own campaign', () {
      final AnnouncedCampaigns campaigns = AnnouncedCampaigns();

      campaigns.add(_campaign('globalonly', 'hash-1'));
      campaigns.add(_campaign('globalsecond', 'hash-2'));

      expect(campaigns.length, 2);
      expect(campaigns.distinctKeys, 2);
      expect(campaigns.distinctHashes, 2);
      expect(campaigns.verdict, 'check: PASS — each event announced its own campaign');
    });

    test('fails when two keys announce the same campaign', () {
      final AnnouncedCampaigns campaigns = AnnouncedCampaigns();

      campaigns.add(_campaign('globalonly', 'hash-1'));
      campaigns.add(_campaign('globalsecond', 'hash-1'));

      expect(campaigns.distinctKeys, 2);
      expect(campaigns.distinctHashes, 1);
      expect(campaigns.verdict, 'check: FAIL — announcements collided');
    });

    test('preserves announcement order and clears', () {
      final AnnouncedCampaigns campaigns = AnnouncedCampaigns();

      campaigns.add(_campaign('globalonly', 'hash-1'));
      campaigns.add(_campaign('globalsecond', 'hash-2'));
      expect(campaigns.entries.map((e) => e.placementKey).toList(), <String>['globalonly', 'globalsecond']);

      campaigns.clear();
      expect(campaigns.length, 0);
      expect(campaigns.verdict, 'check: send both events');
    });
  });
}
