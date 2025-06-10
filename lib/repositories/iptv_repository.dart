// repositories/iptv_repository.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iptv_player/database/database.dart';
import 'package:iptv_player/models/api_configuration_model.dart';
import 'package:iptv_player/models/server_info.dart';
import 'package:iptv_player/models/user_info.dart';
import 'package:iptv_player/repositories/iptv_repository_interface.dart';

class IptvRepository implements IptvRepositoryInterface {
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
  Future<ApiResponse?> getPlayerInfo() async {
    try {
      final response = await _makeRequest('player_api.php');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ApiResponse.fromJson(jsonData);
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
  Future<List<Channel>?> getLiveChannels({String? categoryId}) async {
    try {
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
        return jsonData.map((json) => Channel.fromJson(json)).toList();
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
  Future<List<Movie>?> getMovies({String? categoryId}) async {
    try {
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
        return jsonData.map((json) => Movie.fromJson(json)).toList();
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
  Future<List<Series>?> getSeries({String? categoryId}) async {
    try {
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
        return jsonData.map((json) => Series.fromJson(json)).toList();
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
}
