import 'package:another_iptv_player/screens/watch_history/watch_history_card.dart';
import 'package:another_iptv_player/screens/watch_history/watch_history_section.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/database/database.dart';
import 'package:another_iptv_player/models/content_type.dart';
import 'package:another_iptv_player/models/playlist_content_model.dart';
import 'package:another_iptv_player/models/watch_history.dart';
import 'package:another_iptv_player/repositories/iptv_repository.dart';
import 'package:another_iptv_player/services/app_state.dart';
import 'package:another_iptv_player/services/watch_history_service.dart';
import 'package:another_iptv_player/utils/navigate_by_content_type.dart';
import 'package:another_iptv_player/utils/responsive_helper.dart';
import '../../../services/service_locator.dart';
import '../series/episode_screen.dart';

class WatchHistoryScreen extends StatefulWidget {
  final String playlistId;

  const WatchHistoryScreen({super.key, required this.playlistId});

  @override
  State<WatchHistoryScreen> createState() => _WatchHistoryScreenState();
}

class _WatchHistoryScreenState extends State<WatchHistoryScreen> {
  late WatchHistoryService _historyService;
  late IptvRepository repository;
  final _database = getIt<AppDatabase>();

  List<WatchHistory> _continueWatching = [];
  List<WatchHistory> _recentlyWatched = [];
  List<WatchHistory> _liveHistory = [];
  List<WatchHistory> _movieHistory = [];
  List<WatchHistory> _seriesHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _historyService = WatchHistoryService();
    _loadWatchHistory();
    repository = AppState.repository!;
  }

  Future<void> _loadWatchHistory() async {
    setState(() => _isLoading = true);
    var playlistId = AppState.currentPlaylist!.id;
    try {
      final futures = await Future.wait([
        _historyService.getContinueWatching(playlistId),
        _historyService.getRecentlyWatched(limit: 20, playlistId),
        _historyService.getWatchHistoryByContentType(
          ContentType.liveStream,
          playlistId,
        ),
        _historyService.getWatchHistoryByContentType(
          ContentType.vod,
          playlistId,
        ),
        _historyService.getWatchHistoryByContentType(
          ContentType.series,
          playlistId,
        ),
      ]);

      setState(() {
        _continueWatching = futures[0];
        _recentlyWatched = futures[1];
        _liveHistory = futures[2];
        _movieHistory = futures[3];
        _seriesHistory = futures[4];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İzleme geçmişi yüklenirken hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadWatchHistory,
              child: _buildContent(),
            ),
    );
  }

  Widget _buildContent() {
    final cardWidth = ResponsiveHelper.getCardWidth(context);
    final cardHeight = ResponsiveHelper.getCardHeight(context);

    if (_isAllEmpty()) {
      return _buildEmptyState();
    }

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Text('İzleme Geçmişi'),
            floating: true,
            snap: true,
            elevation: 0,
            actions: [
              // PopupMenuButton<String>(
              //   onSelected: _handleMenuAction,
              //   itemBuilder: (context) => [
              //     PopupMenuItem(
              //       value: 'refresh',
              //       child: Row(
              //         children: [
              //           Icon(Icons.refresh),
              //           SizedBox(width: 8),
              //           Text('Yenile'),
              //         ],
              //       ),
              //     ),
              //     PopupMenuItem(
              //       value: 'clear_old',
              //       child: Row(
              //         children: [
              //           Icon(Icons.auto_delete),
              //           SizedBox(width: 8),
              //           Text('Eski Kayıtları Temizle'),
              //         ],
              //       ),
              //     ),
              //     PopupMenuItem(
              //       value: 'clear_all',
              //       child: Row(
              //         children: [
              //           Icon(Icons.clear_all, color: Colors.red),
              //           SizedBox(width: 8),
              //           Text(
              //             'Tümünü Temizle',
              //             style: TextStyle(color: Colors.red),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Column(
          children: [
            // // Devam Et Bölümü
            // WatchHistorySection(
            //   title: 'Devam Et',
            //   histories: _continueWatching,
            //   cardWidth: cardWidth,
            //   cardHeight: cardHeight,
            //   showProgress: true,
            //   onHistoryTap: _onHistoryTap,
            //   onHistoryRemove: _onHistoryRemove,
            //   onSeeAllTap: () => _showAllHistory('Devam Et', _continueWatching),
            // ),

            // // Son İzlenenler
            // WatchHistorySection(
            //   title: 'Son İzlenen',
            //   histories: _recentlyWatched,
            //   cardWidth: cardWidth,
            //   cardHeight: cardHeight,
            //   onHistoryTap: _onHistoryTap,
            //   onHistoryRemove: _onHistoryRemove,
            //   onSeeAllTap: () =>
            //       _showAllHistory('Son İzlenen', _recentlyWatched),
            // ),

            WatchHistorySection(
              title: 'Canlı Yayınlar',
              histories: _liveHistory,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
              onHistoryTap: _onHistoryTap,
              onHistoryRemove: _onHistoryRemove,
              onSeeAllTap: () =>
                  _showAllHistory('Canlı Yayınlar', _liveHistory),
            ),

            WatchHistorySection(
              title: 'Filmler',
              histories: _movieHistory,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
              showProgress: true,
              onHistoryTap: _onHistoryTap,
              onHistoryRemove: _onHistoryRemove,
              onSeeAllTap: () => _showAllHistory('Filmler', _movieHistory),
            ),

            WatchHistorySection(
              title: 'Diziler',
              histories: _seriesHistory,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
              showProgress: true,
              onHistoryTap: _onHistoryTap,
              onHistoryRemove: _onHistoryRemove,
              onSeeAllTap: () => _showAllHistory('Diziler', _seriesHistory),
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Henüz izleme geçmişiniz bulunmuyor',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Video izlemeye başladığınızda burada görünecek',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bool _isAllEmpty() {
    return _continueWatching.isEmpty &&
        _recentlyWatched.isEmpty &&
        _liveHistory.isEmpty &&
        _movieHistory.isEmpty &&
        _seriesHistory.isEmpty;
  }

  void _onHistoryTap(WatchHistory history) {
    _playContent(history);
  }

  void _onHistoryRemove(WatchHistory history) {
    _showRemoveDialog(history);
  }

  Future<void> _playContent(WatchHistory history) async {
    try {
      switch (history.contentType) {
        case ContentType.liveStream:
          var liveStream = await _database.findLiveStreamById(
            history.streamId,
            AppState.currentPlaylist!.id,
          );

          navigateByContentType(
            context,
            ContentItem(
              history.streamId,
              history.title,
              history.imagePath ?? '',
              history.contentType,
              liveStream: liveStream,
            ),
          );
        case ContentType.vod:
          var movie = await _database.findMovieById(
            history.streamId,
            AppState.currentPlaylist!.id,
          );
          navigateByContentType(
            context,
            ContentItem(
              history.streamId,
              history.title,
              history.imagePath ?? '',
              history.contentType,
              containerExtension: movie!.containerExtension,
              vodStream: movie,
            ),
          );
        case ContentType.series:
          var episode = await _database.findEpisodesById(
            history.streamId,
            AppState.currentPlaylist!.id,
          );

          final seriesResponse = await repository.getSeriesInfo(
            episode!.seriesId,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeScreen(
                seriesInfo: seriesResponse!.seriesInfo,
                seasons: seriesResponse.seasons,
                episodes: seriesResponse.episodes,
                contentItem: ContentItem(
                  episode.episodeId.toString(),
                  history.title,
                  history.imagePath ?? "",
                  ContentType.series,
                  containerExtension: episode.containerExtension,
                  season: episode.season
                ),
                watchHistory: history,
              ),
            ),
          );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video oynatılırken hata oluştu: $e')),
      );
    }
  }

  void _showAllHistory(String title, List<WatchHistory> histories) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WatchHistoryListScreen(
          title: title,
          histories: histories,
          onHistoryTap: _onHistoryTap,
          onHistoryRemove: _onHistoryRemove,
        ),
      ),
    );
  }

  void _showRemoveDialog(WatchHistory history) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Geçmişten Kaldır'),
        content: Text(
          'Bu öğeyi izleme geçmişinden kaldırmak istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeHistory(history);
            },
            child: Text('Kaldır', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _removeHistory(WatchHistory history) async {
    try {
      await _historyService.deleteWatchHistory(
        history.playlistId,
        history.streamId,
      );
      _loadWatchHistory();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('İzleme geçmişinden kaldırıldı')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata oluştu: $e')));
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'refresh':
        _loadWatchHistory();
        break;
      case 'clear_old':
        _showClearOldDialog();
        break;
      case 'clear_all':
        _showClearAllDialog();
        break;
    }
  }

  void _showClearOldDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eski Kayıtları Temizle'),
        content: Text(
          '30 günden eski izleme kayıtlarını silmek istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearOldHistory();
            },
            child: Text('Temizle'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tümünü Temizle'),
        content: Text(
          'Tüm izleme geçmişini silmek istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllHistory();
            },
            child: Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _clearOldHistory() async {
    try {
      await _historyService.cleanOldHistory(daysOld: 30);
      _loadWatchHistory();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Eski kayıtlar temizlendi')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata oluştu: $e')));
    }
  }

  Future<void> _clearAllHistory() async {
    try {
      await _historyService.clearAllHistory();
      _loadWatchHistory();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tüm izleme geçmişi temizlendi')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata oluştu: $e')));
    }
  }
}

class WatchHistoryListScreen extends StatelessWidget {
  final String title;
  final List<WatchHistory> histories;
  final Function(WatchHistory)? onHistoryTap;
  final Function(WatchHistory)? onHistoryRemove;

  const WatchHistoryListScreen({
    super.key,
    required this.title,
    required this.histories,
    this.onHistoryTap,
    this.onHistoryRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = ResponsiveHelper.getCardWidth(context);
    final cardHeight = ResponsiveHelper.getCardHeight(context);
    final crossAxisCount = ResponsiveHelper.getCrossAxisCount(context);

    return Scaffold(
      appBar: AppBar(title: Text(title), elevation: 0),
      body: histories.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Bu kategoride izleme geçmişi bulunmuyor',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: cardWidth / cardHeight,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: histories.length,
              itemBuilder: (context, index) {
                final history = histories[index];
                return WatchHistoryCard(
                  history: history,
                  width: cardWidth,
                  height: cardHeight,
                  showProgress: title == 'Devam Et',
                  onTap: () => onHistoryTap?.call(history),
                  onRemove: () => onHistoryRemove?.call(history),
                );
              },
            ),
    );
  }
}
