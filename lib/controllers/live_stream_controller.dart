import 'package:flutter/material.dart';
import 'package:iptv_player/database/database.dart';
import 'package:iptv_player/repositories/iptv_repository.dart';
import 'package:iptv_player/services/app_state.dart';
import 'package:iptv_player/views/screens/series/progress_loading_screen.dart';

class LiveStreamController {
  AppDatabase _database = AppDatabase();
  IptvRepository _repository = AppState.repository!;


}
