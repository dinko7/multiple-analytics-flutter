import 'package:multiple_analytics_flutter/analytics/models/analytics_event.dart';

enum ShareEventItem { photo, video, app }

class ShareEvent implements AnalyticsEvent {
  final ShareEventItem item;

  ShareEvent({required this.item});

  @override
  String get eventName => 'Share';

  @override
  Map<String, dynamic> get properties => {
    'item': item.toString().split('.').last,
  };
}