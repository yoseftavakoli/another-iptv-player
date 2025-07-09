import 'package:another_iptv_player/screens/app_initializer_screen.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/services/service_locator.dart';
import 'package:provider/provider.dart';
import 'controllers/playlist_controller.dart';
import 'utils/app_themes.dart';

Future<void> main() async {
  await setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlaylistController(),
      child: MaterialApp(
        title: 'Another IPTV Player',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system,
        home: AppInitializerScreen(),
      ),
    );
  }
}