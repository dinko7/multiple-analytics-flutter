import 'package:multiple_analytics_flutter/analytics/models/analytics_event.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

abstract class AnalyticsService {
  void track(AnalyticsEvent event);
  void identify(String userId);
  void reset();
}

class MixpanelAnalyticsService implements AnalyticsService {
  final Mixpanel _mixpanel;

  MixpanelAnalyticsService(this._mixpanel);

  @override
  void track(AnalyticsEvent event) {
    _mixpanel.track(event.eventName, properties: event.properties);
  }

  @override
  void identify(String userId) {
    _mixpanel.identify(userId);
  }

  @override
  void reset() {
    _mixpanel.reset();
  }
}

class PostHogAnalyticsService implements AnalyticsService {
  final Posthog _posthog;

  PostHogAnalyticsService(this._posthog);

  @override
  void track(AnalyticsEvent event) {
    _posthog.capture(
      eventName: event.eventName,
      properties: event.properties.map((key, value) => MapEntry(key, value as Object)),
    );
  }

  @override
  void identify(String userId) {
    _posthog.identify(userId: userId);
  }

  @override
  void reset() {
    _posthog.reset();
  }
}

class CompoundAnalyticsService implements AnalyticsService {
  final List<AnalyticsService> _services;

  CompoundAnalyticsService(this._services);

  @override
  void track(AnalyticsEvent event) {
    for (var service in _services) {
      service.track(event);
    }
  }

  @override
  void identify(String userId) {
    for (var service in _services) {
      service.identify(userId);
    }
  }

  @override
  void reset() {
    for (var service in _services) {
      service.reset();
    }
  }
}