//
// class AnalyticsService {
//   AnalyticsService() {
//     _analytics = FirebaseAnalytics.instance;
//   }
//
//   late FirebaseAnalytics _analytics;
//
//   FirebaseAnalyticsObserver getAnalyticsObserver() =>
//       FirebaseAnalyticsObserver(analytics: _analytics);
//
//   Future customLog(String name) async {
//     await _analytics.logScreenView(screenName: name);
//   }
//
// }
