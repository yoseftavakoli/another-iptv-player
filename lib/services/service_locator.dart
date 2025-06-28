import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:another_iptv_player/database/database.dart';
import 'package:another_iptv_player/utils/audio_handler.dart';
import 'package:media_kit/media_kit.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<MyAudioHandler>(await initAudioService());

  // var player = Player(
  //   configuration: const PlayerConfiguration(title: 'Media Kit Player'),
  // );
  // var videoController = VideoController(player);

  // getIt.registerSingleton<Player>(player);
  // print('Player registered');

  // getIt.registerSingleton<VideoController>(videoController);
  // print('VideoController registered');

  // print('Setting up service locator...');

  // getIt.registerSingleton<MediaKitAudioHandler>(await initAudioService());
  // print('AudioHandler registered');

  // print('Service locator setup complete');
}