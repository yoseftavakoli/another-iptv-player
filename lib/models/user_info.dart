import 'package:drift/drift.dart';
import 'package:iptv_player/database/database.dart';

class UserInfo {
  final String username;
  final String password;
  final String message;
  final int auth;
  final String status;
  final String expDate;
  final String isTrial;
  final String activeCons;
  final String createdAt;
  final String maxConnections;
  final List<String> allowedOutputFormats;

  UserInfo({
    required this.username,
    required this.password,
    required this.message,
    required this.auth,
    required this.status,
    required this.expDate,
    required this.isTrial,
    required this.activeCons,
    required this.createdAt,
    required this.maxConnections,
    required this.allowedOutputFormats,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      message: json['message'] ?? '',
      auth: json['auth'] ?? 0,
      status: json['status'] ?? '',
      expDate: json['exp_date'] ?? '',
      isTrial: json['is_trial'] ?? '',
      activeCons: json['active_cons'] ?? '',
      createdAt: json['created_at'] ?? '',
      maxConnections: json['max_connections'] ?? '',
      allowedOutputFormats: json['allowed_output_formats'] != null
          ? List<String>.from(json['allowed_output_formats'])
          : [],
    );
  }
}

// models/category.dart
enum CategoryType {
  live,
  vod,
  series;

  String get value {
    switch (this) {
      case CategoryType.live:
        return 'live';
      case CategoryType.vod:
        return 'vod';
      case CategoryType.series:
        return 'series';
    }
  }

  static CategoryType fromString(String value) {
    switch (value) {
      case 'live':
        return CategoryType.live;
      case 'vod':
        return CategoryType.vod;
      case 'series':
        return CategoryType.series;
      default:
        throw ArgumentError('Invalid category type: $value');
    }
  }
}

class Category {
  final String categoryId;
  final String categoryName;
  final int parentId;
  final String playlistId;
  final CategoryType type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.parentId,
    required this.playlistId,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(
    Map<String, dynamic> json,
    String playlistId,
    CategoryType type,
  ) {
    return Category(
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      parentId: int.tryParse(json['parent_id']?.toString() ?? '0') ?? 0,
      playlistId: playlistId,
      type: type,
    );
  }

  factory Category.fromDrift(CategoriesData driftObject) {
    return Category(
      categoryId: driftObject.categoryId,
      categoryName: driftObject.categoryName,
      parentId: driftObject.parentId,
      playlistId: driftObject.playlistId,
      type: CategoryType.fromString(driftObject.type),
      createdAt: driftObject.createdAt,
      updatedAt: driftObject.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'parent_id': parentId,
      'playlist_id': playlistId,
      'type': type.value,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Drift insertion için companion object
  CategoriesCompanion toCompanion() {
    return CategoriesCompanion(
      categoryId: Value(categoryId),
      categoryName: Value(categoryName),
      parentId: Value(parentId),
      playlistId: Value(playlistId),
      type: Value(type.value),
      updatedAt: Value(DateTime.now()),
    );
  }

  @override
  String toString() {
    return 'Category(categoryId: $categoryId, categoryName: $categoryName, parentId: $parentId, playlistId: $playlistId, type: ${type.value})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category &&
        other.categoryId == categoryId &&
        other.categoryName == categoryName &&
        other.parentId == parentId &&
        other.playlistId == playlistId &&
        other.type == type;
  }

  @override
  int get hashCode =>
      categoryId.hashCode ^
      categoryName.hashCode ^
      parentId.hashCode ^
      playlistId.hashCode ^
      type.hashCode;
}

// models/channel.dart
class Channel {
  final String streamId;
  final String name;
  final String streamIcon;
  final String categoryId;
  final String epgChannelId;

  Channel({
    required this.streamId,
    required this.name,
    required this.streamIcon,
    required this.categoryId,
    required this.epgChannelId,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      streamId: json['stream_id']?.toString() ?? '',
      name: json['name'] ?? '',
      streamIcon: json['stream_icon'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      epgChannelId: json['epg_channel_id'] ?? '',
    );
  }
}

// models/movie.dart
class Movie {
  final String streamId;
  final String name;
  final String streamIcon;
  final String categoryId;
  final String containerExtension;
  final String plot;
  final String cast;
  final String director;
  final String genre;
  final String releasedate;
  final String rating;

  Movie({
    required this.streamId,
    required this.name,
    required this.streamIcon,
    required this.categoryId,
    required this.containerExtension,
    required this.plot,
    required this.cast,
    required this.director,
    required this.genre,
    required this.releasedate,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      streamId: json['stream_id']?.toString() ?? '',
      name: json['name'] ?? '',
      streamIcon: json['stream_icon'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      containerExtension: json['container_extension'] ?? '',
      plot: json['plot'] ?? '',
      cast: json['cast'] ?? '',
      director: json['director'] ?? '',
      genre: json['genre'] ?? '',
      releasedate: json['releasedate'] ?? '',
      rating: json['rating']?.toString() ?? '',
    );
  }
}

// models/series.dart
class Series {
  final String seriesId;
  final String name;
  final String cover;
  final String plot;
  final String cast;
  final String director;
  final String genre;
  final String releasedate;
  final String rating;
  final String categoryId;

  Series({
    required this.seriesId,
    required this.name,
    required this.cover,
    required this.plot,
    required this.cast,
    required this.director,
    required this.genre,
    required this.releasedate,
    required this.rating,
    required this.categoryId,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      seriesId: json['series_id']?.toString() ?? '',
      name: json['name'] ?? '',
      cover: json['cover'] ?? '',
      plot: json['plot'] ?? '',
      cast: json['cast'] ?? '',
      director: json['director'] ?? '',
      genre: json['genre'] ?? '',
      releasedate: json['releasedate'] ?? '',
      rating: json['rating']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
    );
  }
}
