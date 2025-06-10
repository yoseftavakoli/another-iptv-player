import 'package:drift/drift.dart';
import 'package:iptv_player/database/database.dart';

class SeriesStream {
  final String seriesId;
  final String name;
  final String cover;
  final String plot;
  final String cast;
  final String director;
  final String genre;
  final String releaseDate;
  final String rating;
  final double rating5based;
  final String youtubeTrailer;
  final String episodeRunTime;
  final String categoryId;
  final String? playlistId;

  SeriesStream({
    required this.seriesId,
    required this.name,
    required this.cover,
    required this.plot,
    required this.cast,
    required this.director,
    required this.genre,
    required this.releaseDate,
    required this.rating,
    required this.rating5based,
    required this.youtubeTrailer,
    required this.episodeRunTime,
    required this.categoryId,
    this.playlistId,
  });

  factory SeriesStream.fromJson(Map<String, dynamic> json, String playlistId) {
    return SeriesStream(
      seriesId: json['series_id']?.toString() ?? '',
      name: json['name'] ?? '',
      cover: json['cover'] ?? '',
      plot: json['plot'] ?? '',
      cast: json['cast'] ?? '',
      director: json['director'] ?? '',
      genre: json['genre'] ?? '',
      releaseDate: json['releaseDate'] ?? '',
      rating: json['rating']?.toString() ?? '',
      rating5based: (json['rating_5based'] as num?)?.toDouble() ?? 0.0,
      youtubeTrailer: json['youtube_trailer'] ?? '',
      episodeRunTime: json['episode_run_time'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      playlistId: playlistId
    );
  }

  // Drift'ten SeriesStream oluşturmak için
  factory SeriesStream.fromDriftSeriesStream(
    SeriesStreamsData driftSeriesStream,
  ) {
    return SeriesStream(
      seriesId: driftSeriesStream.seriesId,
      name: driftSeriesStream.name,
      cover: driftSeriesStream.cover,
      plot: driftSeriesStream.plot,
      cast: driftSeriesStream.cast,
      director: driftSeriesStream.director,
      genre: driftSeriesStream.genre,
      releaseDate: driftSeriesStream.releaseDate,
      rating: driftSeriesStream.rating,
      rating5based: driftSeriesStream.rating5based,
      youtubeTrailer: driftSeriesStream.youtubeTrailer,
      episodeRunTime: driftSeriesStream.episodeRunTime,
      categoryId: driftSeriesStream.categoryId,
      playlistId: driftSeriesStream.playlistId,
    );
  }

  // Drift'e kaydetmek için
  SeriesStreamsCompanion toDriftCompanion() {
    return SeriesStreamsCompanion(
      seriesId: Value(seriesId),
      name: Value(name),
      cover: Value(cover),
      plot: Value(plot),
      cast: Value(cast),
      director: Value(director),
      genre: Value(genre),
      releaseDate: Value(releaseDate),
      rating: Value(rating),
      rating5based: Value(rating5based),
      youtubeTrailer: Value(youtubeTrailer),
      episodeRunTime: Value(episodeRunTime),
      categoryId: Value(categoryId),
      playlistId: Value(playlistId ?? ''),
    );
  }

  @override
  String toString() {
    return 'SeriesStream{seriesId: $seriesId, name: $name, categoryId: $categoryId, rating: $rating, playlistId: $playlistId}';
  }
}
