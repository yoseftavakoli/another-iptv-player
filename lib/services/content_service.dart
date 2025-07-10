import 'package:another_iptv_player/models/category_view_model.dart';
import 'package:another_iptv_player/models/content_type.dart';
import 'package:another_iptv_player/models/playlist_content_model.dart';
import 'package:another_iptv_player/services/app_state.dart';
import '../models/category_type.dart';

class ContentService {
  Future<List<ContentItem>> fetchContentByCategory(CategoryViewModel category) async {
    final repository = AppState.repository!;
    final categoryId = category.category.categoryId;

    try {
      switch (category.category.type) {
        case CategoryType.live:
          return await _fetchLiveChannels(repository, categoryId);
        case CategoryType.vod:
          return await _fetchMovies(repository, categoryId);
        case CategoryType.series:
          return await _fetchSeries(repository, categoryId);
      }
    } catch (e) {
      throw Exception('İçerik yüklenirken hata oluştu: $e');
    }
  }

  Future<List<ContentItem>> _fetchLiveChannels(dynamic repository, String categoryId) async {
    try {
      final result = await repository.getLiveChannelsByCategoryId(categoryId: categoryId);

      if (result == null) return <ContentItem>[];

      // Tip kontrolü ve dönüşümü
      if (result is List) {
        return result.map((channel) {
          return ContentItem(
            channel.streamId,
            channel.name,
            channel.streamIcon,
            ContentType.liveStream,
            liveStream: channel,
          );
        }).toList();
      }

      return <ContentItem>[];
    } catch (e) {
      throw Exception('Canlı kanallar yüklenirken hata: $e');
    }
  }

  Future<List<ContentItem>> _fetchMovies(dynamic repository, String categoryId) async {
    try {
      final result = await repository.getMovies(categoryId: categoryId);

      if (result == null) return <ContentItem>[];

      // Tip kontrolü ve dönüşümü
      if (result is List) {
        return result.map((movie) {
          return ContentItem(
            movie.streamId,
            movie.name,
            movie.streamIcon,
            ContentType.vod,
            containerExtension: movie.containerExtension,
            vodStream: movie,
          );
        }).toList();
      }

      return <ContentItem>[];
    } catch (e) {
      throw Exception('Filmler yüklenirken hata: $e');
    }
  }

  Future<List<ContentItem>> _fetchSeries(dynamic repository, String categoryId) async {
    try {
      final result = await repository.getSeries(categoryId: categoryId);

      if (result == null) return <ContentItem>[];

      // Tip kontrolü ve dönüşümü
      if (result is List) {
        return result.map((serie) {
          return ContentItem(
            serie.seriesId,
            serie.name,
            serie.cover,
            ContentType.series,
            seriesStream: serie,
          );
        }).toList();
      }

      return <ContentItem>[];
    } catch (e) {
      throw Exception('Diziler yüklenirken hata: $e');
    }
  }
}