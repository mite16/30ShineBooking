import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Local notification integration (Module 10.5 / LO7): call [show] right
/// after a key user action succeeds — login, booking confirmed — same
/// pattern as the class demo (NotificationService.show() called from
/// AuthService right after login() succeeds).
///
/// Supported by the plugin on Android / iOS / macOS / Linux only (no Web,
/// no Windows) — on an unsupported platform [show] just logs and returns,
/// so the rest of the app keeps working unaffected.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  int _nextId = 0;

  static const _channelId = 'booking30shine_channel';
  static const _channelName = 'Thông báo 30Shine Booking';
  static const _channelDescription = 'Thông báo sau đăng nhập và đặt lịch thành công';

  bool get _isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux);

  Future<void> init() async {
    if (_initialized || !_isSupportedPlatform) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
      macOS: iosInit,
    );

    await _plugin.initialize(settings);

    // Android 13+ (API 33) requires runtime permission, per Module 10.5.
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  Future<void> show({required String title, required String body}) async {
    debugPrint('[NotificationService] show(title: "$title", body: "$body")');

    if (!_isSupportedPlatform) {
      debugPrint('[NotificationService] Skipped: not supported on this platform (web/windows).');
      return;
    }

    try {
      await init();
      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      );
      const details = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      );
      await _plugin.show(_nextId++, title, body, details);
    } catch (e) {
      // Never let a notification failure break the actual user action
      // (login/booking) that triggered it.
      debugPrint('[NotificationService] show() failed: $e');
    }
  }
}
