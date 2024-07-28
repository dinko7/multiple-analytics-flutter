import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:multiple_analytics_flutter/env.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import 'analytics/models/share_event.dart';
import 'analytics/services/analytics_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final mixpanel = await Mixpanel.init(Env.mixpanelToken, optOutTrackingDefault: false, trackAutomaticEvents: true);
  mixpanel.setLoggingEnabled(true);

  final analyticsService = CompoundAnalyticsService([
    MixpanelAnalyticsService(mixpanel),
    PostHogAnalyticsService(Posthog()),
  ]);

  runApp(MyApp(analyticsService: analyticsService));
}

class MyApp extends StatelessWidget {
  final AnalyticsService analyticsService;

  const MyApp({Key? key, required this.analyticsService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(analyticsService: analyticsService),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final AnalyticsService analyticsService;

  const MyHomePage({super.key, required this.analyticsService});

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Share Photo'),
                  onTap: () => _onShareItem(ShareEventItem.photo, context)),
              ListTile(
                  leading: const Icon(Icons.videocam),
                  title: const Text('Share Video'),
                  onTap: () => _onShareItem(ShareEventItem.video, context)),
              ListTile(
                  leading: const Icon(Icons.app_shortcut),
                  title: const Text('Share App'),
                  onTap: () => _onShareItem(ShareEventItem.app, context)),
            ],
          ),
        );
      },
    );
  }

  void _onShareItem(ShareEventItem item, BuildContext context) {
    analyticsService.track(ShareEvent(item: item));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Shared ${item.toString().split('.').last}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showShareOptions(context),
          child: const Text('Share'),
        ),
      ),
    );
  }
}