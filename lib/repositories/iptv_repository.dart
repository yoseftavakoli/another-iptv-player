import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:http/http.dart' as http;
import 'package:iptv_player/database/database.dart';
import 'package:iptv_player/models/api_configuration_model.dart';
import 'package:iptv_player/models/api_response.dart';
import 'package:iptv_player/models/category.dart';
import 'package:iptv_player/models/live_stream.dart';
import 'package:iptv_player/models/series_response.dart';
import 'package:iptv_player/models/vod_streams.dart';
import 'package:iptv_player/models/series.dart';

class IptvRepository {
  final ApiConfig _config;
  final AppDatabase _database;
  final String _playlistId;

  IptvRepository(this._config, this._database, this._playlistId);

  Future<http.Response> _makeRequest(
    String endpoint, {
    Map<String, String>? additionalParams,
  }) async {
    final params = Map<String, String>.from(_config.baseParams);
    if (additionalParams != null) {
      params.addAll(additionalParams);
    }

    final uri = Uri.parse(
      '${_config.baseUrl}/$endpoint',
    ).replace(queryParameters: params);

    return await http.get(uri, headers: {'Content-Type': 'application/json'});
  }

  @override
  Future<ApiResponse?> getPlayerInfo({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        var userInfo = await _database.getUserInfoByPlaylistId(_playlistId);
        var serverInfo = await _database.getServerInfoByPlaylistId(_playlistId);

        if (userInfo != null && serverInfo != null) {
          return ApiResponse(
            userInfo: userInfo,
            serverInfo: serverInfo,
            playlistId: _playlistId,
          );
        }
      }

      final response = await _makeRequest('player_api.php');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        var apiResponse = ApiResponse.fromJson(jsonData, _playlistId);

        await _database.insertOrUpdateUserInfo(apiResponse.userInfo);
        await _database.insertOrUpdateServerInfo(apiResponse.serverInfo);

        return apiResponse;
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('Player Info Error: $e');
      return null;
    }
  }

  @override
  Future<List<LiveStream>?> getLiveChannels({
    String? categoryId,
    bool forceRefresh = false,
  }) async {
    try {
      if (!forceRefresh) {
        var liveStreams = await _database.getLiveStreams(_playlistId);

        if (liveStreams.isNotEmpty) {
          return liveStreams;
        }
      }

      final additionalParams = <String, String>{'action': 'get_live_streams'};

      if (categoryId != null) {
        additionalParams['category_id'] = categoryId;
      }

      final response = await _makeRequest(
        'player_api.php',
        additionalParams: additionalParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        var liveStreams = jsonData
            .map((json) => LiveStream.fromJson(json, _playlistId))
            .toList();

        await _database.deleteLiveStreamsByPlaylistId(_playlistId);
        await _database.insertLiveStreams(liveStreams);
        return liveStreams;
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('Live Channels Error: $e');
      return null;
    }
  }

  Future<List<LiveStream>?> getLiveChannelsByCategoryId({
    required String categoryId,
    bool forceRefresh = false,
  }) async {
    try {
      if (!forceRefresh) {
        var liveStreams = await _database.getLiveStreamsByCategoryId(
          _playlistId,
          categoryId,
        );

        if (liveStreams.isNotEmpty) {
          return liveStreams;
        }
      }

      final additionalParams = <String, String>{'action': 'get_live_streams'};

      if (categoryId != null) {
        additionalParams['category_id'] = categoryId;
      }

      final response = await _makeRequest(
        'player_api.php',
        additionalParams: additionalParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        var liveStreams = jsonData
            .map((json) => LiveStream.fromJson(json, _playlistId))
            .toList();

        await _database.deleteLiveStreamsByPlaylistId(_playlistId);
        await _database.insertLiveStreams(liveStreams);
        return liveStreams;
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('Live Channels Error: $e');
      return null;
    }
  }

  @override
  Future<List<VodStream>?> getMovies({
    String? categoryId,
    bool forceRefresh = false,
  }) async {
    try {
      if (!forceRefresh) {
        if (categoryId != null) {
          var vodStreams = await _database.getVodStreamsByCategoryAndPlaylistId(
            categoryId: categoryId,
            playlistId: _playlistId,
          );

          if (vodStreams.isNotEmpty) {
            return vodStreams;
          }
        } else {
          var vodStreams = await _database.getVodStreamsByPlaylistId(
            _playlistId,
          );

          if (vodStreams.isNotEmpty) {
            return vodStreams;
          }
        }
      }

      final additionalParams = <String, String>{'action': 'get_vod_streams'};

      if (categoryId != null) {
        additionalParams['category_id'] = categoryId;
      }

      final response = await _makeRequest(
        'player_api.php',
        additionalParams: additionalParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        var vodStreams = jsonData
            .map((json) => VodStream.fromJson(json, _playlistId))
            .toList();

        await _database.deleteVodStreamsByPlaylistId(_playlistId);
        await _database.insertVodStreams(vodStreams);

        return vodStreams;
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('Movies Error: $e');
      return null;
    }
  }

  @override
  Future<List<SeriesStream>?> getSeries({
    String? categoryId,
    bool forceRefresh = false,
  }) async {
    try {
      if (!forceRefresh) {
        if (categoryId != null) {
          var series = await _database.getSeriesStreamsByCategoryAndPlaylistId(
            categoryId: categoryId,
            playlistId: _playlistId,
          );

          if (series.isNotEmpty) {
            return series;
          }
        } else {
          var series = await _database.getSeriesStreamsByPlaylistId(
            _playlistId,
          );

          if (series.isNotEmpty) {
            return series;
          }
        }
      }

      final additionalParams = <String, String>{'action': 'get_series'};

      if (categoryId != null) {
        additionalParams['category_id'] = categoryId;
      }

      final response = await _makeRequest(
        'player_api.php',
        additionalParams: additionalParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        var series = jsonData
            .map((json) => SeriesStream.fromJson(json, _playlistId))
            .toList();

        await _database.deleteSeriesStreamsByPlaylistId(_playlistId);
        await _database.insertSeriesStreams(series);

        return series;
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('Series Error: $e');
      return null;
    }
  }

  // Canlı Yayın Kategorileri
  @override
  Future<List<Category>?> getLiveCategories({bool forceRefresh = false}) async {
    return _getCategories(
      CategoryType.live,
      'get_live_categories',
      forceRefresh,
    );
  }

  // VOD Kategorileri
  @override
  Future<List<Category>?> getVodCategories({bool forceRefresh = false}) async {
    return _getCategories(CategoryType.vod, 'get_vod_categories', forceRefresh);
  }

  // Series Kategorileri
  @override
  Future<List<Category>?> getSeriesCategories({
    bool forceRefresh = false,
  }) async {
    return _getCategories(
      CategoryType.series,
      'get_series_categories',
      forceRefresh,
    );
  }

  // Ortak kategori çekme methodu
  Future<List<Category>?> _getCategories(
    CategoryType type,
    String action,
    bool forceRefresh,
  ) async {
    try {
      // Önce cache'den kontrol et
      if (!forceRefresh) {
        final cachedCategories = await _database.getCategoriesByTypeAndPlaylist(
          _playlistId,
          type,
        );
        if (cachedCategories.isNotEmpty) {
          return cachedCategories;
        }
      }

      // API'den çek
      final additionalParams = <String, String>{'action': action};

      final response = await _makeRequest(
        'player_api.php',
        additionalParams: additionalParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final categories = jsonData
            .map((json) => Category.fromJson(json, _playlistId, type))
            .toList();

        // Eski kategorileri sil ve yenileri ekle
        await _database.deleteCategoriesByTypeAndPlaylist(_playlistId, type);
        await _database.insertCategories(categories);

        return categories;
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('${type.value} Categories Error: $e');
      // Hata durumunda cache'den dön
      final cachedCategories = await _database.getCategoriesByTypeAndPlaylist(
        _playlistId,
        type,
      );
      return cachedCategories.isNotEmpty ? cachedCategories : null;
    }
  }

  // Tüm kategorileri al
  Future<Map<CategoryType, List<Category>>?> getAllCategories({
    bool forceRefresh = false,
  }) async {
    try {
      final results = await Future.wait([
        getLiveCategories(forceRefresh: forceRefresh),
        getVodCategories(forceRefresh: forceRefresh),
        getSeriesCategories(forceRefresh: forceRefresh),
      ]);

      return {
        CategoryType.live: results[0] ?? [],
        CategoryType.vod: results[1] ?? [],
        CategoryType.series: results[2] ?? [],
      };
    } catch (e) {
      print('Get All Categories Error: $e');
      return await _database.getAllCategoriesByPlaylist(_playlistId);
    }
  }

  // Cache'i temizle
  Future<void> clearCategoriesCache({CategoryType? type}) async {
    if (type != null) {
      await _database.deleteCategoriesByTypeAndPlaylist(_playlistId, type);
    } else {
      await _database.deleteAllCategoriesByPlaylist(_playlistId);
    }
  }

  // Kategori ara
  Future<List<Category>> searchCategories(
    CategoryType type,
    String query,
  ) async {
    return await _database.searchCategories(_playlistId, type, query);
  }

  // Series detaylarını getiren metod
  Future<SeriesDetailResponse?> getSeriesInfo(
    String seriesId, {
    bool forceRefresh = false,
  }) async {
    try {
      if (!forceRefresh) {
        // Önce database'den kontrol et
        final seriesInfo = await _database.getSeriesInfo(seriesId, _playlistId);
        final seasons = await _database.getSeasonsBySeriesId(
          seriesId,
          _playlistId,
        );
        final episodes = await _database.getEpisodesBySeriesId(
          seriesId,
          _playlistId,
        );

        if (seriesInfo != null && seasons.isNotEmpty) {
          return SeriesDetailResponse(
            seriesInfo: seriesInfo,
            seasons: seasons,
            episodes: episodes,
            playlistId: _playlistId,
          );
        }
      }

      // API'den çek
      final response = await _makeRequest(
        'player_api.php',
        additionalParams: {'action': 'get_series_info', 'series_id': seriesId},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Database'e kaydet
        await _saveSeriesDataToDatabase(seriesId, jsonData);

        // Database'den tekrar oku ve return et
        final seriesInfo = await _database.getSeriesInfo(seriesId, _playlistId);
        final seasons = await _database.getSeasonsBySeriesId(
          seriesId,
          _playlistId,
        );
        final episodes = await _database.getEpisodesBySeriesId(
          seriesId,
          _playlistId,
        );

        return SeriesDetailResponse(
          seriesInfo: seriesInfo!,
          seasons: seasons,
          episodes: episodes,
          playlistId: _playlistId,
        );
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('Series Info Error: $e');
      return null;
    }
  }

  // Series episodlarını sezona göre getir
  Future<List<EpisodesData>> getSeriesEpisodesBySeason(
    String seriesId,
    int seasonNumber, {
    bool forceRefresh = false,
  }) async {
    try {
      if (!forceRefresh) {
        final episodes = await _database.getEpisodesBySeason(
          seriesId,
          seasonNumber,
          _playlistId,
        );
        if (episodes.isNotEmpty) {
          return episodes;
        }
      }

      // Eğer episodlar yok ise series info'yu çek
      await getSeriesInfo(seriesId, forceRefresh: true);

      return await _database.getEpisodesBySeason(
        seriesId,
        seasonNumber,
        _playlistId,
      );
    } catch (e) {
      print('Get Episodes By Season Error: $e');
      return [];
    }
  }

  Future<void> _saveSeriesDataToDatabase(
    String seriesId,
    Map<String, dynamic> data,
  ) async {
    try {
      // Önce mevcut verileri temizle
      await _database.clearSeriesData(seriesId, _playlistId);

      // Series Info kaydet
      final info = data['info'];
      if (info != null) {
        final seriesInfoCompanion = SeriesInfosCompanion(
          seriesId: drift.Value(seriesId),
          playlistId: drift.Value(_playlistId),
          name: drift.Value(_safeString(info['name'])),
          cover: drift.Value(_safeString(info['cover'])),
          plot: drift.Value(_safeString(info['plot'])),
          cast: drift.Value(_safeString(info['cast'])),
          director: drift.Value(_safeString(info['director'])),
          genre: drift.Value(_safeString(info['genre'])),
          releaseDate: drift.Value(_safeString(info['releaseDate'])),
          lastModified: drift.Value(_safeString(info['last_modified'])),
          rating: drift.Value(_safeString(info['rating'])),
          rating5based: drift.Value(_safeInt(info['rating_5based'])),
          backdropPath: drift.Value(
            _getFirstBackdropPath(info['backdrop_path']),
          ),
          youtubeTrailer: drift.Value(_safeString(info['youtube_trailer'])),
          episodeRunTime: drift.Value(_safeString(info['episode_run_time'])),
          categoryId: drift.Value(_safeString(info['category_id'])),
        );

        await _database.insertSeriesInfo(seriesInfoCompanion);
      }

      // Seasons kaydet
      final seasons = data['seasons'];
      if (seasons is List) {
        for (final season in seasons) {
          final seasonCompanion = SeasonsCompanion(
            seriesId: drift.Value(seriesId),
            playlistId: drift.Value(_playlistId),
            airDate: drift.Value(_safeString(season['air_date'])),
            episodeCount: drift.Value(_safeInt(season['episode_count'])),
            seasonId: drift.Value(_safeInt(season['id']) ?? 0),
            name: drift.Value(_safeString(season['name'])),
            overview: drift.Value(_safeString(season['overview'])),
            seasonNumber: drift.Value(_safeInt(season['season_number']) ?? 1),
            voteAverage: drift.Value(_safeInt(season['vote_average'])),
            cover: drift.Value(_safeString(season['cover'])),
            coverBig: drift.Value(_safeString(season['cover_big'])),
          );

          await _database.insertSeason(seasonCompanion);
        }
      }

      // Episodes kaydet
      final episodes = data['episodes'];
      if (episodes is Map<String, dynamic>) {
        for (final seasonKey in episodes.keys) {
          final seasonEpisodes = episodes[seasonKey];

          if (seasonEpisodes is List) {
            for (final episode in seasonEpisodes) {
              final episodeCompanion = EpisodesCompanion(
                seriesId: drift.Value(seriesId),
                playlistId: drift.Value(_playlistId),
                episodeId: drift.Value(_safeString(episode['id'])),
                episodeNum: drift.Value(_safeInt(episode['episode_num']) ?? 0),
                title: drift.Value(_safeString(episode['title'])),
                containerExtension: drift.Value(
                  _safeString(episode['container_extension']),
                ),
                season: drift.Value(_safeInt(episode['season']) ?? 1),
                customSid: drift.Value(_safeString(episode['custom_sid'])),
                added: drift.Value(_safeString(episode['added'])),
                directSource: drift.Value(
                  _safeString(episode['direct_source']),
                ),

                // Episode info
                tmdbId: drift.Value(_safeInt(episode['info']?['tmdb_id'])),
                releasedate: drift.Value(
                  _safeString(episode['info']?['releasedate']),
                ),
                plot: drift.Value(_safeString(episode['info']?['plot'])),
                durationSecs: drift.Value(
                  _safeInt(episode['info']?['duration_secs']),
                ),
                duration: drift.Value(
                  _safeString(episode['info']?['duration']),
                ),
                movieImage: drift.Value(
                  _safeString(episode['info']?['movie_image']),
                ),
                bitrate: drift.Value(_safeInt(episode['info']?['bitrate'])),
                rating: drift.Value(_safeDouble(episode['info']?['rating'])),
              );

              await _database.insertEpisode(episodeCompanion);
            }
          }
        }
      }

      print('Series data saved to database successfully');
    } catch (e) {
      print('Save series data to database error: $e');
      rethrow;
    }
  }

  int _safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return 0;
      try {
        return double.parse(trimmed).toInt();
      } catch (e) {
        return 0;
      }
    }
    try {
      return int.parse(value.toString());
    } catch (e) {
      return 0;
    }
  }

  double? _safeDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) return value;
    if (value is int) return value.toDouble();

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;

      try {
        return double.parse(trimmed);
      } catch (e) {
        print('Double parsing error for value: "$value" - $e');
        return null;
      }
    }

    try {
      return double.parse(value.toString());
    } catch (e) {
      print('Double parsing error for value: "$value" - $e');
      return null;
    }
  }

  bool _safeBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;

    if (value is String) {
      final trimmed = value.trim().toLowerCase();
      return trimmed == 'true' || trimmed == '1' || trimmed == 'yes';
    }

    if (value is int) return value != 0;

    return false;
  }

  String _safeString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value.trim();
    return value.toString().trim();
  }

  String? _getFirstBackdropPath(dynamic backdropPath) {
    if (backdropPath == null) return null;

    if (backdropPath is List && backdropPath.isNotEmpty) {
      final first = backdropPath[0];
      final safeFirst = _safeString(first);
      return safeFirst.isEmpty ? null : safeFirst;
    }

    if (backdropPath is String) {
      final safe = _safeString(backdropPath);
      return safe.isEmpty ? null : safe;
    }

    return null;
  }
}
