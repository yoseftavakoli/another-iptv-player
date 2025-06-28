import 'package:another_iptv_player/models/content_type.dart';
import 'package:another_iptv_player/models/live_stream.dart';
import 'package:another_iptv_player/models/series.dart';
import 'package:another_iptv_player/models/vod_streams.dart';

class ContentItem {
  final String id;
  final String name;
  final String imagePath;
  final String? description;
  final Duration? duration;
  final String? coverPath;
  final String? containerExtension;
  final ContentType contentType;
  final LiveStream? liveStream;
  final VodStream? vodStream;
  final SeriesStream? seriesStream;

  ContentItem(
    this.id,
    this.name,
    this.imagePath,
    this.contentType, {
    this.description,
    this.duration,
    this.coverPath,
    this.containerExtension,
    this.liveStream,
    this.vodStream,
    this.seriesStream,
  });
}

class PlaylistContentModel {}
