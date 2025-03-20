import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  //Initialize the FlutterNotificationPlugin
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //Initialize the notification plugin
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Crea el canal de notificación aquí (requerido desde la v19)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'favorites_channel', // id
      'Favoritos', // nombre visible
      description: 'Notificaciones de favoritos en la Pokedex',
      importance: Importance.high,
    );

    // Importante inicializar settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Inicializamos el plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Creamos el canal en Android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'favorites_channel', // Debe coincidir con el canal creado arriba
      'Favoritos',
      channelDescription: 'Notificaciones de favoritos en la Pokedex',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 3000,
      title,
      body,
      notificationDetails,
    );
  }
}
