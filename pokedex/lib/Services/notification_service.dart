import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/*
class NotificationService {
  //Initialize the FlutterNotificationPlugin
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(NotificationResponse notificationResponse) async {}

  //Initialize the notification plugin
  static Future<void> init() async {
    //Define the Android initialization settings
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    //Define the Ios initialization settings
    const DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings();

    //Combine Android and Ios initialization settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    //Initialize the plugin with the specified settings

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    //Request notification permission for android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }
  //Show an instant Notification
  static Future<void> showInstantNotification(String title, String body) async{
    //Define Notification Details
    const NotificationDetails plataformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails("channel_Id", "channel_Name",
              importance: Importance.high, priority: Priority.high),
      iOS: DarwinNotificationDetails()
    );
    await flutterLocalNotificationsPlugin.show(0, title, body, plataformChannelSpecifics);
  }

  //Show a Schelude Notification
  static Future<void> scheduleNotification(String title, String body, int seconds,) async {
    await Future.delayed(Duration(seconds: seconds), () async {
      await showInstantNotification(title, body);
    });
  }
}
*/




















class NotificationService {
  //Initialize the FlutterNotificationPlugin
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //Initialize the notification plugin
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // ⚠️ Crea el canal de notificación aquí (requerido desde la v19)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'favorites_channel', // id
      'Favoritos', // nombre visible
      description: 'Notificaciones de favoritos en la Pokedex',
      importance: Importance.high,
    );

    // ⚠️ Importante inicializar settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Inicializamos el plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // ⚠️ Creamos el canal en Android
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
      DateTime.now().millisecondsSinceEpoch ~/ 3000, // ID único para que siempre aparezca
      title,
      body,
      notificationDetails,
    );
  }
}
