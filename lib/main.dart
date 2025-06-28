import 'package:flutter/material.dart';
import 'package:another_iptv_player/services/service_locator.dart';
import 'package:provider/provider.dart';
import 'database/playlist_controller.dart';
import 'views/screens/home/home_screen.dart';

Future<void> main() async {
  await setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PlaylistController())],
      child: MaterialApp(
        title: 'Another IPTV Player',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
