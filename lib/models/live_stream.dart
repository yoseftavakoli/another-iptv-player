import 'package:drift/drift.dart';
import 'package:iptv_player/database/database.dart';

class LiveStream {
  final String streamId;
  final String name;
  final String streamIcon;
  final String categoryId;
  final String epgChannelId;
  final String? playlistId;

  LiveStream({
    required this.streamId,
    required this.name,
    required this.streamIcon,
    required this.categoryId,
    required this.epgChannelId,
    this.playlistId,
  });

  factory LiveStream.fromJson(Map<String, dynamic> json, String playlistId) {
    return LiveStream(
      streamId: json['stream_id']?.toString() ?? '',
      name: json['name'] ?? '',
      streamIcon: json['stream_icon'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      epgChannelId: json['epg_channel_id'] ?? '',
      playlistId: playlistId
    );
  }

  // Drift'ten LiveStream oluşturmak için
  factory LiveStream.fromDriftLiveStream(LiveStreamsData driftLiveStream) {
    return LiveStream(
      streamId: driftLiveStream.streamId,
      name: driftLiveStream.name,
      streamIcon: driftLiveStream.streamIcon,
      categoryId: driftLiveStream.categoryId,
      epgChannelId: driftLiveStream.epgChannelId,
      playlistId: driftLiveStream.playlistId,
    );
  }

  // Drift'e kaydetmek için
  LiveStreamsCompanion toDriftCompanion(String playlistId) {
    return LiveStreamsCompanion(
      streamId: Value(streamId),
      name: Value(name),
      streamIcon: Value(streamIcon),
      categoryId: Value(categoryId),
      epgChannelId: Value(epgChannelId),
      playlistId: Value(playlistId),
    );
  }
}
