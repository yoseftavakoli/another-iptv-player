import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:another_iptv_player/database/database.dart';
import 'package:another_iptv_player/utils/audio_handler.dart';
import 'package:media_kit/media_kit.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerSingleton<MyAudioHandler>(await initAudioService());
  getIt.registerSingleton<AppDatabase>(AppDatabase());

  MediaKit.ensureInitialized();
}