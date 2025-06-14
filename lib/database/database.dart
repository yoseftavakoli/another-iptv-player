import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:iptv_player/models/category.dart';
import 'package:iptv_player/models/live_stream.dart';
import 'package:iptv_player/models/series.dart';
import 'package:iptv_player/models/vod_streams.dart';
import 'package:iptv_player/models/server_info.dart';
import 'package:iptv_player/models/user_info.dart';
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

@DataClassName('UserInfosData')
class UserInfos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get playlistId => text()();
  TextColumn get username => text()();
  TextColumn get password => text()();
  TextColumn get message => text()();
  IntColumn get auth => integer()();
  TextColumn get status => text()();
  TextColumn get expDate => text()();
  TextColumn get isTrial => text()();
  TextColumn get activeCons => text()();
  TextColumn get createdAt => text()();
  TextColumn get maxConnections => text()();
  TextColumn get allowedOutputFormats => text()();
}

@DataClassName('ServerInfosData')
class ServerInfos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get playlistId => text()();
  TextColumn get url => text()();
  TextColumn get port => text()();
  TextColumn get httpsPort => text()();
  TextColumn get serverProtocol => text()();
  TextColumn get rtmpPort => text()();
  TextColumn get timezone => text()();
  IntColumn get timestampNow => integer()();
  TextColumn get timeNow => text()();
}

@DataClassName('LiveStreamsData')
class LiveStreams extends Table {
  TextColumn get streamId => text()();
  TextColumn get name => text()();
  TextColumn get streamIcon => text()();
  TextColumn get categoryId => text()();
  TextColumn get epgChannelId => text()();
  TextColumn get playlistId => text()(); // Ekstra property
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {streamId, playlistId};
}

@DataClassName('VodStreamsData')
class VodStreams extends Table {
  TextColumn get streamId => text()();
  TextColumn get name => text()();
  TextColumn get streamIcon => text()();
  TextColumn get categoryId => text()();
  TextColumn get rating => text()();
  RealColumn get rating5based => real()();
  TextColumn get containerExtension => text()();
  TextColumn get playlistId => text()(); // Ekstra property
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {streamId, playlistId}; // Composite primary key
}

@DataClassName('SeriesStreamsData')
class SeriesStreams extends Table {
  TextColumn get seriesId => text()();
  TextColumn get name => text()();
  TextColumn get cover => text()();
  TextColumn get plot => text()();
  TextColumn get cast => text()();
  TextColumn get director => text()();
  TextColumn get genre => text()();
  TextColumn get releaseDate => text()();
  TextColumn get rating => text()();
  RealColumn get rating5based => real()();
  TextColumn get youtubeTrailer => text()();
  TextColumn get episodeRunTime => text()();
  TextColumn get categoryId => text()();
  TextColumn get playlistId => text()(); // Ekstra property
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get lastModified => text()();
  TextColumn get backdropPath => text()(); // JSON string olarak saklanacak

  @override
  Set<Column> get primaryKey => {seriesId, playlistId};
}

@DriftDatabase(
  tables: [
    Playlists,
    Categories,
    UserInfos,
    ServerInfos,
    LiveStreams,
    VodStreams,
    SeriesStreams,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7; // SeriesStreams tablosu eklendiği için versiyon artırıldı
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
        await (select(categories)..where(
              (tbl) =>
                  tbl.playlistId.equals(playlistId) &
                  tbl.type.equals(type.value),
            ))
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

  // === USER INFO İŞLEMLERİ ===

  // UserInfo ekleme/güncelleme (upsert)
  Future<int> insertOrUpdateUserInfo(UserInfo userInfo) async {
    final existingUser = await getUserInfoByPlaylistId(userInfo.playlistId);

    if (existingUser != null) {
      // Güncelle
      return await (update(
        userInfos,
      )..where((tbl) => tbl.playlistId.equals(userInfo.playlistId))).write(
        UserInfosCompanion(
          username: Value(userInfo.username),
          password: Value(userInfo.password),
          message: Value(userInfo.message),
          auth: Value(userInfo.auth),
          status: Value(userInfo.status),
          expDate: Value(userInfo.expDate),
          isTrial: Value(userInfo.isTrial),
          activeCons: Value(userInfo.activeCons),
          createdAt: Value(userInfo.createdAt),
          maxConnections: Value(userInfo.maxConnections),
          allowedOutputFormats: Value(userInfo.allowedOutputFormats.join(',')),
        ),
      );
    } else {
      // Yeni ekle
      return await into(userInfos).insert(
        UserInfosCompanion.insert(
          playlistId: userInfo.playlistId,
          username: userInfo.username,
          password: userInfo.password,
          message: userInfo.message,
          auth: userInfo.auth,
          status: userInfo.status,
          expDate: userInfo.expDate,
          isTrial: userInfo.isTrial,
          activeCons: userInfo.activeCons,
          createdAt: userInfo.createdAt,
          maxConnections: userInfo.maxConnections,
          allowedOutputFormats: userInfo.allowedOutputFormats.join(','),
        ),
      );
    }
  }

  // PlaylistId'ye göre UserInfo getirme
  Future<UserInfo?> getUserInfoByPlaylistId(String playlistId) async {
    final query = select(userInfos)
      ..where((tbl) => tbl.playlistId.equals(playlistId));

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    return UserInfo(
      id: result.id,
      playlistId: result.playlistId,
      username: result.username,
      password: result.password,
      message: result.message,
      auth: result.auth,
      status: result.status,
      expDate: result.expDate,
      isTrial: result.isTrial,
      activeCons: result.activeCons,
      createdAt: result.createdAt,
      maxConnections: result.maxConnections,
      allowedOutputFormats: result.allowedOutputFormats.isNotEmpty
          ? result.allowedOutputFormats.split(',')
          : [],
    );
  }

  // Tüm UserInfo'ları getirme
  Future<List<UserInfo>> getAllUserInfos() async {
    final results = await select(userInfos).get();
    return results
        .map(
          (result) => UserInfo(
            id: result.id,
            playlistId: result.playlistId,
            username: result.username,
            password: result.password,
            message: result.message,
            auth: result.auth,
            status: result.status,
            expDate: result.expDate,
            isTrial: result.isTrial,
            activeCons: result.activeCons,
            createdAt: result.createdAt,
            maxConnections: result.maxConnections,
            allowedOutputFormats: result.allowedOutputFormats.isNotEmpty
                ? result.allowedOutputFormats.split(',')
                : [],
          ),
        )
        .toList();
  }

  // PlaylistId'ye göre UserInfo silme
  Future<int> deleteUserInfoByPlaylistId(String playlistId) async {
    return await (delete(
      userInfos,
    )..where((tbl) => tbl.playlistId.equals(playlistId))).go();
  }

  // === SERVER INFO İŞLEMLERİ ===

  // ServerInfo ekleme/güncelleme (upsert)
  Future<int> insertOrUpdateServerInfo(ServerInfo serverInfo) async {
    final existingServer = await getServerInfoByPlaylistId(
      serverInfo.playlistId,
    );

    if (existingServer != null) {
      // Güncelle
      return await (update(
        serverInfos,
      )..where((tbl) => tbl.playlistId.equals(serverInfo.playlistId))).write(
        ServerInfosCompanion(
          url: Value(serverInfo.url),
          port: Value(serverInfo.port),
          httpsPort: Value(serverInfo.httpsPort),
          serverProtocol: Value(serverInfo.serverProtocol),
          rtmpPort: Value(serverInfo.rtmpPort),
          timezone: Value(serverInfo.timezone),
          timestampNow: Value(serverInfo.timestampNow),
          timeNow: Value(serverInfo.timeNow),
        ),
      );
    } else {
      // Yeni ekle
      return await into(serverInfos).insert(
        ServerInfosCompanion.insert(
          playlistId: serverInfo.playlistId,
          url: serverInfo.url,
          port: serverInfo.port,
          httpsPort: serverInfo.httpsPort,
          serverProtocol: serverInfo.serverProtocol,
          rtmpPort: serverInfo.rtmpPort,
          timezone: serverInfo.timezone,
          timestampNow: serverInfo.timestampNow,
          timeNow: serverInfo.timeNow,
        ),
      );
    }
  }

  // PlaylistId'ye göre ServerInfo getirme
  Future<ServerInfo?> getServerInfoByPlaylistId(String playlistId) async {
    final query = select(serverInfos)
      ..where((tbl) => tbl.playlistId.equals(playlistId));

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    return ServerInfo(
      id: result.id,
      playlistId: result.playlistId,
      url: result.url,
      port: result.port,
      httpsPort: result.httpsPort,
      serverProtocol: result.serverProtocol,
      rtmpPort: result.rtmpPort,
      timezone: result.timezone,
      timestampNow: result.timestampNow,
      timeNow: result.timeNow,
    );
  }

  // Tüm ServerInfo'ları getirme
  Future<List<ServerInfo>> getAllServerInfos() async {
    final results = await select(serverInfos).get();
    return results
        .map(
          (result) => ServerInfo(
            id: result.id,
            playlistId: result.playlistId,
            url: result.url,
            port: result.port,
            httpsPort: result.httpsPort,
            serverProtocol: result.serverProtocol,
            rtmpPort: result.rtmpPort,
            timezone: result.timezone,
            timestampNow: result.timestampNow,
            timeNow: result.timeNow,
          ),
        )
        .toList();
  }

  // PlaylistId'ye göre ServerInfo silme
  Future<int> deleteServerInfoByPlaylistId(String playlistId) async {
    return await (delete(
      serverInfos,
    )..where((tbl) => tbl.playlistId.equals(playlistId))).go();
  }

  // Live Streams
  Future<void> insertLiveStreams(List<LiveStream> liveStreams) async {
    final liveStreamsCompanions = liveStreams
        .map(
          (liveStream) => LiveStreamsCompanion(
            streamId: Value(liveStream.streamId),
            name: Value(liveStream.name),
            streamIcon: Value(liveStream.streamIcon),
            categoryId: Value(liveStream.categoryId),
            epgChannelId: Value(liveStream.epgChannelId),
            playlistId: Value(liveStream.playlistId ?? ''),
          ),
        )
        .toList();

    await batch((batch) {
      batch.insertAllOnConflictUpdate(this.liveStreams, liveStreamsCompanions);
    });
  }

  Future<List<LiveStream>> getLiveStreams(String playlistId) async {
    final rows = await (select(
      liveStreams,
    )..where((ls) => ls.playlistId.equals(playlistId))).get();

    return rows.map((row) => LiveStream.fromDriftLiveStream(row)).toList();
  }

  Future<List<LiveStream>> getLiveStreamsByCategoryId(
    String playlistId,
    String categoryId,
  ) async {
    final rows =
        await (select(liveStreams)..where(
              (ls) =>
                  ls.playlistId.equals(playlistId) &
                  ls.categoryId.equals(categoryId),
            ))
            .get();

    return rows.map((row) => LiveStream.fromDriftLiveStream(row)).toList();
  }

  Future<void> deleteLiveStreamsByPlaylistId(String playlistId) async {
    await (delete(
      liveStreams,
    )..where((ls) => ls.playlistId.equals(playlistId))).go();
  }

  // Vod Streams
  Future<void> insertVodStreams(List<VodStream> vodStreams) async {
    final vodStreamsCompanions = vodStreams
        .map((vodStream) => vodStream.toDriftCompanion())
        .toList();

    await batch((batch) {
      batch.insertAllOnConflictUpdate(this.vodStreams, vodStreamsCompanions);
    });
  }

  Future<List<VodStream>> getVodStreamsByPlaylistId(String playlistId) async {
    final rows = await (select(
      vodStreams,
    )..where((vs) => vs.playlistId.equals(playlistId))).get();

    return rows.map((row) => VodStream.fromDriftVodStream(row)).toList();
  }

  Future<List<VodStream>> getVodStreamsByCategoryAndPlaylistId({
    required String categoryId,
    required String playlistId,
  }) async {
    final rows =
        await (select(vodStreams)..where(
              (vs) =>
                  vs.categoryId.equals(categoryId) &
                  vs.playlistId.equals(playlistId),
            ))
            .get();

    return rows.map((row) => VodStream.fromDriftVodStream(row)).toList();
  }

  Future<List<VodStream>> getVodStreamsByCategory(String categoryId) async {
    final rows = await (select(
      vodStreams,
    )..where((vs) => vs.categoryId.equals(categoryId))).get();

    return rows.map((row) => VodStream.fromDriftVodStream(row)).toList();
  }

  Future<List<VodStream>> getVodStreamsFiltered({
    String? categoryId,
    String? playlistId,
    String? searchQuery,
  }) async {
    final query = select(vodStreams);

    if (categoryId != null && playlistId != null) {
      query.where(
        (vs) =>
            vs.categoryId.equals(categoryId) & vs.playlistId.equals(playlistId),
      );
    } else if (categoryId != null) {
      query.where((vs) => vs.categoryId.equals(categoryId));
    } else if (playlistId != null) {
      query.where((vs) => vs.playlistId.equals(playlistId));
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.where((vs) => vs.name.like('%$searchQuery%'));
    }

    final rows = await query.get();
    return rows.map((row) => VodStream.fromDriftVodStream(row)).toList();
  }

  Future<void> deleteVodStreamsByPlaylistId(String playlistId) async {
    await (delete(
      vodStreams,
    )..where((vs) => vs.playlistId.equals(playlistId))).go();
  }

  Future<void> deleteVodStreamsByCategoryAndPlaylistId({
    required String categoryId,
    required String playlistId,
  }) async {
    await (delete(vodStreams)..where(
          (vs) =>
              vs.categoryId.equals(categoryId) &
              vs.playlistId.equals(playlistId),
        ))
        .go();
  }

  // SeriesStreams için CRUD operations
  Future<void> insertSeriesStreams(List<SeriesStream> seriesStreams) async {
    final seriesStreamsCompanions = seriesStreams
        .map((seriesStream) => seriesStream.toDriftCompanion())
        .toList();

    await batch((batch) {
      batch.insertAllOnConflictUpdate(
        this.seriesStreams,
        seriesStreamsCompanions,
      );
    });
  }

  Future<List<SeriesStream>> getSeriesStreamsByPlaylistId(
    String playlistId,
  ) async {
    final rows = await (select(
      seriesStreams,
    )..where((ss) => ss.playlistId.equals(playlistId))).get();

    return rows.map((row) => SeriesStream.fromDriftSeriesStream(row)).toList();
  }

  Future<List<SeriesStream>> getSeriesStreamsByCategoryAndPlaylistId({
    required String categoryId,
    required String playlistId,
  }) async {
    final rows =
        await (select(seriesStreams)..where(
              (ss) =>
                  ss.categoryId.equals(categoryId) &
                  ss.playlistId.equals(playlistId),
            ))
            .get();

    return rows.map((row) => SeriesStream.fromDriftSeriesStream(row)).toList();
  }

  Future<List<SeriesStream>> getSeriesStreamsByCategory(
    String categoryId,
  ) async {
    final rows = await (select(
      seriesStreams,
    )..where((ss) => ss.categoryId.equals(categoryId))).get();

    return rows.map((row) => SeriesStream.fromDriftSeriesStream(row)).toList();
  }

  Future<List<SeriesStream>> getSeriesStreamsFiltered({
    String? categoryId,
    String? playlistId,
    String? searchQuery,
  }) async {
    final query = select(seriesStreams);

    if (categoryId != null && playlistId != null) {
      query.where(
        (ss) =>
            ss.categoryId.equals(categoryId) & ss.playlistId.equals(playlistId),
      );
    } else if (categoryId != null) {
      query.where((ss) => ss.categoryId.equals(categoryId));
    } else if (playlistId != null) {
      query.where((ss) => ss.playlistId.equals(playlistId));
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.where((ss) => ss.name.like('%$searchQuery%'));
    }

    final rows = await query.get();
    return rows.map((row) => SeriesStream.fromDriftSeriesStream(row)).toList();
  }

  Future<void> deleteSeriesStreamsByPlaylistId(String playlistId) async {
    await (delete(
      seriesStreams,
    )..where((ss) => ss.playlistId.equals(playlistId))).go();
  }

  Future<void> deleteSeriesStreamsByCategoryAndPlaylistId({
    required String categoryId,
    required String playlistId,
  }) async {
    await (delete(seriesStreams)..where(
          (ss) =>
              ss.categoryId.equals(categoryId) &
              ss.playlistId.equals(playlistId),
        ))
        .go();
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
      if (from < 3) {
        // UserInfo ve ServerInfo tablolarını ekle
        await m.createTable(userInfos);
        await m.createTable(serverInfos);
      }
      if (from < 4) {
        // LiveStreams tablosunu oluştur
        await m.createTable(liveStreams);
      }
      if (from < 5) {
        await m.createTable(vodStreams);
      }
      if (from < 6) {
        await m.createTable(seriesStreams);
      }
      if (from <= 6) {
        // Yeni kolonları varsayılan değerlerle ekle
        await m.addColumn(seriesStreams, seriesStreams.lastModified);
        await m.addColumn(seriesStreams, seriesStreams.backdropPath);

        // Varolan kayıtlar için varsayılan değerler set etmek isterseniz:
        await customStatement('''
        UPDATE series_streams 
        SET last_modified = '0', backdrop_path = '[]' 
        WHERE last_modified IS NULL OR backdrop_path IS NULL
      ''');
      }
    },
  );

  // database.dart dosyanızda
  Future<void> deleteDatabase() async {
    await close(); // Önce bağlantıyı kapat
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'playlists.db'));

    if (await file.exists()) {
      await file.delete();
      print('Database silindi');
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'playlists.db'));
    return NativeDatabase(file);
  });
}
