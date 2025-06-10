// database/database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:iptv_player/models/category.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/playlist_model.dart';

part 'database.g.dart';

@DataClassName('PlaylistData')
class Playlists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get url => text().nullable()();
  TextColumn get username => text().nullable()();
  TextColumn get password => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CategoriesData')
class Categories extends Table {
  TextColumn get categoryId => text()();
  TextColumn get categoryName => text()();
  IntColumn get parentId => integer().withDefault(const Constant(0))();
  TextColumn get playlistId => text()();
  TextColumn get type => text()(); // 'live', 'vod', 'series'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {categoryId, playlistId, type};
}

@DriftDatabase(tables: [Playlists, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Kategori tablosu eklendiği için versiyon artırıldı

  // === PLAYLIST İŞLEMLERİ ===

  // Playlist oluştur
  Future<void> insertPlaylist(Playlist playlist) async {
    await into(playlists).insert(
      PlaylistsCompanion(
        id: Value(playlist.id),
        name: Value(playlist.name),
        type: Value(playlist.type.toString()),
        url: Value(playlist.url),
        username: Value(playlist.username),
        password: Value(playlist.password),
        createdAt: Value(playlist.createdAt),
      ),
    );
  }

  // Tüm playlistleri getir
  Future<List<Playlist>> getAllPlaylists() async {
    final playlistData = await select(playlists).get();
    return playlistData.map((data) => _convertToPlaylist(data)).toList();
  }

  // ID'ye göre playlist getir
  Future<Playlist?> getPlaylistById(String id) async {
    final query = select(playlists)..where((p) => p.id.equals(id));
    final result = await query.getSingleOrNull();
    return result != null ? _convertToPlaylist(result) : null;
  }

  // Playlist sil
  Future<void> deletePlaylistById(String id) async {
    // Önce playlist'e ait kategorileri sil
    await deleteAllCategoriesByPlaylist(id);
    // Sonra playlist'i sil
    await (delete(playlists)..where((p) => p.id.equals(id))).go();
  }

  // Playlist güncelle
  Future<void> updatePlaylist(Playlist playlist) async {
    await (update(playlists)..where((p) => p.id.equals(playlist.id))).write(
      PlaylistsCompanion(
        name: Value(playlist.name),
        type: Value(playlist.type.toString()),
        url: Value(playlist.url),
        username: Value(playlist.username),
        password: Value(playlist.password),
      ),
    );
  }

  // Tip filtreleme
  Future<List<Playlist>> getPlaylistsByType(PlaylistType type) async {
    final query = select(playlists)
      ..where((p) => p.type.equals(type.toString()));
    final playlistData = await query.get();
    return playlistData.map((data) => _convertToPlaylist(data)).toList();
  }

  // === KATEGORİ İŞLEMLERİ ===

  // Kategorileri tip ve playlist'e göre getir
  Future<List<Category>> getCategoriesByTypeAndPlaylist(
    String playlistId,
    CategoryType type,
  ) async {
    final categoriesData =
        await (select(categories)
              ..where(
                (tbl) =>
                    tbl.playlistId.equals(playlistId) &
                    tbl.type.equals(type.value),
              )
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.categoryName)]))
            .get();

    return categoriesData.map((cat) => Category.fromDrift(cat)).toList();
  }

  // Kategorileri ekle/güncelle
  Future<void> insertCategories(List<Category> categoryList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(
        categories,
        categoryList.map((cat) => cat.toCompanion()).toList(),
      );
    });
  }

  // Belirli tip ve playlist'teki kategorileri sil
  Future<void> deleteCategoriesByTypeAndPlaylist(
    String playlistId,
    CategoryType type,
  ) async {
    await (delete(categories)..where(
          (tbl) =>
              tbl.playlistId.equals(playlistId) & tbl.type.equals(type.value),
        ))
        .go();
  }

  // Playlist'teki tüm kategorileri sil
  Future<void> deleteAllCategoriesByPlaylist(String playlistId) async {
    await (delete(
      categories,
    )..where((tbl) => tbl.playlistId.equals(playlistId))).go();
  }

  // Parent kategorileri getir
  Future<List<Category>> getParentCategories(
    String playlistId,
    CategoryType type,
  ) async {
    final categoriesData =
        await (select(categories)
              ..where(
                (tbl) =>
                    tbl.playlistId.equals(playlistId) &
                    tbl.type.equals(type.value) &
                    tbl.parentId.equals(0),
              )
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.categoryName)]))
            .get();

    return categoriesData.map((cat) => Category.fromDrift(cat)).toList();
  }

  // Alt kategorileri getir
  Future<List<Category>> getSubCategories(
    String playlistId,
    CategoryType type,
    String parentId,
  ) async {
    final categoriesData =
        await (select(categories)
              ..where(
                (tbl) =>
                    tbl.playlistId.equals(playlistId) &
                    tbl.type.equals(type.value) &
                    tbl.parentId.equals(int.parse(parentId)),
              )
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.categoryName)]))
            .get();

    return categoriesData.map((cat) => Category.fromDrift(cat)).toList();
  }

  // Kategori ara
  Future<List<Category>> searchCategories(
    String playlistId,
    CategoryType type,
    String query,
  ) async {
    final categoriesData =
        await (select(categories)
              ..where(
                (tbl) =>
                    tbl.playlistId.equals(playlistId) &
                    tbl.type.equals(type.value) &
                    tbl.categoryName.contains(query),
              )
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.categoryName)]))
            .get();

    return categoriesData.map((cat) => Category.fromDrift(cat)).toList();
  }

  // Kategori sayısını getir
  Future<int> getCategoryCount(String playlistId, CategoryType type) async {
    final result =
        await (select(categories)..where(
              (tbl) =>
                  tbl.playlistId.equals(playlistId) &
                  tbl.type.equals(type.value),
            ))
            .get();

    return result.length;
  }

  // Tüm kategorileri getir (tüm tipler)
  Future<Map<CategoryType, List<Category>>> getAllCategoriesByPlaylist(
    String playlistId,
  ) async {
    final allCategoriesData =
        await (select(categories)
              ..where((tbl) => tbl.playlistId.equals(playlistId))
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.categoryName)]))
            .get();

    final result = <CategoryType, List<Category>>{};

    for (final type in CategoryType.values) {
      result[type] = allCategoriesData
          .where((cat) => cat.type == type.value)
          .map((cat) => Category.fromDrift(cat))
          .toList();
    }

    return result;
  }

  // Playlist'in kategori istatistiklerini getir
  Future<Map<CategoryType, int>> getCategoryStatsByPlaylist(
    String playlistId,
  ) async {
    final result = <CategoryType, int>{};

    for (final type in CategoryType.values) {
      final count = await getCategoryCount(playlistId, type);
      result[type] = count;
    }

    return result;
  }

  // Kategori ID'sine göre tek kategori getir
  Future<Category?> getCategoryById(
    String playlistId,
    String categoryId,
    CategoryType type,
  ) async {
    final query = select(categories)
      ..where(
        (tbl) =>
            tbl.playlistId.equals(playlistId) &
            tbl.categoryId.equals(categoryId) &
            tbl.type.equals(type.value),
      );

    final result = await query.getSingleOrNull();
    return result != null ? Category.fromDrift(result) : null;
  }

  // Kategori var mı kontrol et
  Future<bool> categoryExists(
    String playlistId,
    String categoryId,
    CategoryType type,
  ) async {
    final category = await getCategoryById(playlistId, categoryId, type);
    return category != null;
  }

  // === YARDIMCI METODLAR ===

  // PlaylistData'yı Playlist'e çevir
  Playlist _convertToPlaylist(PlaylistData data) {
    return Playlist(
      id: data.id,
      name: data.name,
      type: PlaylistType.values.firstWhere((e) => e.toString() == data.type),
      url: data.url,
      username: data.username,
      password: data.password,
      createdAt: data.createdAt,
    );
  }

  // Database migration
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Kategori tablosunu ekle
        await m.createTable(categories);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'playlists.db'));
    return NativeDatabase(file);
  });
}
