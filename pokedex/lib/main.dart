import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // <-- Esto faltaba
import 'package:pokedex/ModeDark_ModeLight/theme_dark.dart';
import 'package:pokedex/ModeDark_ModeLight/theme_light.dart';
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

class MyApp extends StatefulWidget{

  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  bool isDarkMode = false;


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: isDarkMode? ThemeMode.dark : ThemeMode.light,
      home: InitialPage(
        isDarkMode: isDarkMode,
        onToggleTheme: toggleTheme,
      ),
    );
  }

  void toggleTheme(){
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

 }
