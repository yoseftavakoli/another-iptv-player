import 'package:another_iptv_player/models/playlist_model.dart';
import 'package:another_iptv_player/repositories/iptv_repository.dart';

abstract class AppState {
  static Playlist? currentPlaylist;
  static IptvRepository? repository;
}
