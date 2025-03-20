import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // <-- Esto faltaba
import 'Page/init_page.dart';
import 'package:pokedex/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la data de zonas horarias
  tz.initializeTimeZones();

  // Inicializa el servicio de notificaciones
  await NotificationService.initialize();

  // Solicita permisos de notificaciones (Android 13+ y iOS)
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: InitialPage(),
    );
  }
 }
