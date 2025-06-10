// repositories/iptv_repository_interface.dart
import 'package:iptv_player/models/category.dart';
import 'package:iptv_player/models/channel.dart';
import 'package:iptv_player/models/movie.dart';
import 'package:iptv_player/models/series.dart';
import 'package:iptv_player/models/server_info.dart';
import 'package:iptv_player/models/user_info.dart';

abstract class IptvRepositoryInterface {
  // Player bilgileri
  Future<ApiResponse?> getPlayerInfo();

  // Kategori işlemleri - force refresh parametresi eklendi
  Future<Map<CategoryType, List<Category>>?> getAllCategories({
    bool forceRefresh = false,
  });
  Future<List<Category>?> getLiveCategories({bool forceRefresh = false});
  Future<List<Category>?> getVodCategories({bool forceRefresh = false});
  Future<List<Category>?> getSeriesCategories({bool forceRefresh = false});

  // İçerik işlemleri
  Future<List<Channel>?> getLiveChannels({String? categoryId});
  Future<List<Movie>?> getMovies({String? categoryId});
  Future<List<Series>?> getSeries({String? categoryId});

  // Kategori yardımcı metodları
  Future<List<Category>> searchCategories(CategoryType type, String query);
}
