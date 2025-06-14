import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:iptv_player/utils/audio_handler.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  MediaKit.ensureInitialized();

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
