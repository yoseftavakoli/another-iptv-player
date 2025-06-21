import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:iptv_player/database/database.dart';
import 'package:iptv_player/utils/audio_handler.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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

Future<void> deleteAllSqliteDatabases() async {
  final appDir = await getApplicationDocumentsDirectory();
  final files = appDir.listSync();

  for (final file in files) {
    if (file is File && file.path.endsWith('.sql')) {
      await file.delete();
      print('Deleted: ${file.path}');
    }
  }
}

Future<void> deleteDriftDatabase(String name) async {
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = p.join(dir.path, '$name.sqlite');
  final dbFile = File(dbPath);

  if (await dbFile.exists()) {
    await dbFile.delete();
    print('Deleted database: $dbPath');
  } else {
    print('Database file not found at: $dbPath');
  }

  // Ayrıca isolate port'larını da temizle
  IsolateNameServer.removePortNameMapping('drift-db/$name');
  IsolateNameServer.removePortNameMapping('drift-db/$name/control');
}
