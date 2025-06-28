import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:iptv_player/models/playlist_content_model.dart';
import 'package:iptv_player/models/watch_history.dart';
import 'package:iptv_player/repositories/user_prefrences.dart';
import 'package:iptv_player/services/app_state.dart';
import 'package:iptv_player/services/event_bus.dart';
import 'package:iptv_player/services/watch_history_service.dart';
import 'package:iptv_player/views/widgets/video_widget.dart';
import 'package:media_kit/media_kit.dart' hide PlayerState;
import 'package:media_kit_video/media_kit_video.dart';
import '../../models/content_type.dart';
import '../../services/player_state.dart';
import '../../services/service_locator.dart';
import '../../utils/audio_handler.dart';
import '../../utils/build_media_url.dart';

class PlayerWidget extends StatefulWidget {
  final ContentItem contentItem;
  final double? aspectRatio;
  final bool showControls;
  final bool showInfo;
  final VoidCallback? onFullscreen;

  const PlayerWidget({
    Key? key,
    required this.contentItem,
    this.aspectRatio,
    this.showControls = true,
    this.showInfo = false,
    this.onFullscreen,
  }) : super(key: key);

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget>
    with WidgetsBindingObserver {
  late StreamSubscription videoTrackSubscription;
  late StreamSubscription audioTrackSubscription;
  late StreamSubscription subtitleTranckSubscription;
  late StreamSubscription contentItemIndexChangedSubscription;

  late Player _player;
  VideoController? _videoController;
  late WatchHistoryService watchHistoryService;
  final MyAudioHandler _audioHandler = getIt<MyAudioHandler>();
  List<ContentItem>? _queue;
  late ContentItem contentItem;

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    contentItem = widget.contentItem;
    PlayerState.title = widget.contentItem.name;
    WidgetsBinding.instance.addObserver(this);
    _player = Player(configuration: PlayerConfiguration(osc: false));
    watchHistoryService = WatchHistoryService();

    super.initState();
    videoTrackSubscription = EventBus()
        .on<VideoTrack>('video_track_changed')
        .listen((VideoTrack data) async {
          _player.setVideoTrack(data);
          await UserPreferences.setVideoTrack(data.id);
        });

    audioTrackSubscription = EventBus()
        .on<AudioTrack>('audio_track_changed')
        .listen((AudioTrack data) async {
          _player.setAudioTrack(data);
          await UserPreferences.setAudioTrack(data.language ?? 'null');
        });

    subtitleTranckSubscription = EventBus()
        .on<SubtitleTrack>('subtitle_track_changed')
        .listen((SubtitleTrack data) async {
          _player.setSubtitleTrack(data);
          await UserPreferences.setSubtitleTrack(data.language ?? 'null');
        });

    _initializeAudioService();
  }

  @override
  void dispose() {
    _player.dispose();
    _audioHandler.setPlayer(null);
    videoTrackSubscription.cancel();
    audioTrackSubscription.cancel();
    subtitleTranckSubscription.cancel();
    contentItemIndexChangedSubscription.cancel();
    super.dispose();
  }

  Future<void> _initializeQueue() async {
    switch (widget.contentItem.contentType) {
      case ContentType.liveStream:
        _queue =
            (await AppState.repository!.getLiveChannelsByCategoryId(
              categoryId: widget.contentItem.liveStream!.categoryId,
            ))!.map((x) {
              return ContentItem(
                x.streamId,
                x.name,
                x.streamIcon,
                ContentType.liveStream,
                liveStream: x,
              );
            }).toList();
      case ContentType.vod:
      case ContentType.series:
    }
  }

  Future<void> _initializeAudioService() async {
    if (!mounted) return;

    _audioHandler.setPlayer(_player);
    // _audioHandler.setCurrentMediaItem(
    //   title: contentItem.name,
    //   artist: _getContentTypeDisplayName(),
    //   artUri: contentItem.imagePath,
    // );

    await _initializeQueue();
    if (!mounted) return;

    _videoController = VideoController(_player);

    var watchHistory = await watchHistoryService.getWatchHistory(
      AppState.currentPlaylist!.id,
      contentItem.id,
    );
    if (!mounted) return; // Check after async operation

    var playlist = _queue?.map((x) {
      return Media(buildMediaUrl(x));
    }).toList();

    var mediaUrl = buildMediaUrl(contentItem);

    if (playlist != null) {
      var currentItemIndex = playlist.indexOf(
        Media(buildMediaUrl(contentItem)),
      );
      await _player.open(
        Playlist(playlist, index: currentItemIndex),
        play: true,
      );
    } else {
      await _player.open(
        Playlist([
          Media(mediaUrl, start: watchHistory?.watchDuration ?? Duration()),
        ]),
        play: true,
      );
    }
    if (!mounted) return; // Check after async operation

    _player.stream.tracks.listen((event) async {
      if (!mounted) return; // Check in stream listener

      PlayerState.videos = event.video;
      PlayerState.audios = event.audio;
      PlayerState.subtitles = event.subtitle;

      EventBus().emit('player_tracks', event);

      await _player.setVideoTrack(
        VideoTrack(await UserPreferences.getVideoTrack(), null, null),
      );

      var selectedAudioLanguage = await UserPreferences.getAudioTrack();
      var possibleAudioTrack = event.audio.firstWhere(
        (x) => x.language == selectedAudioLanguage,
        orElse: AudioTrack.auto,
      );

      await _player.setAudioTrack(possibleAudioTrack);

      var selectedSubtitleLanguage = await UserPreferences.getSubtitleTrack();
      var possibleSubtitleLanguage = event.subtitle.firstWhere(
        (x) => x.language == selectedSubtitleLanguage,
        orElse: SubtitleTrack.auto,
      );

      await _player.setSubtitleTrack(possibleSubtitleLanguage);
    });

    _player.stream.track.listen((event) async {
      if (!mounted) return; // Check in stream listener

      PlayerState.selectedVideo = _player.state.track.video;
      PlayerState.selectedAudio = _player.state.track.audio;
      PlayerState.selectedSubtitle = _player.state.track.subtitle;

      var volume = await UserPreferences.getVolume();
      await _player.setVolume(volume);
    });

    _player.stream.volume.listen((event) async {
      await UserPreferences.setVolume(event);
    });

    _player.stream.position.listen((position) async {
      await watchHistoryService.saveWatchHistory(
        WatchHistory(
          playlistId: AppState.currentPlaylist!.id,
          contentType: contentItem.contentType,
          streamId: contentItem.id,
          lastWatched: DateTime.now(),
          title: contentItem.name,
          imagePath: contentItem.imagePath,
          totalDuration: _player.state.duration,
          watchDuration: position,
        ),
      );
    });

    _player.stream.error.listen((error) {
      print('PLAYER ERROR -> $error');
    });

    _player.stream.playlist.listen((playlist) {
      if (!mounted) return; // Check in stream listener

      contentItem = _queue?[playlist.index] ?? widget.contentItem;
      PlayerState.title = contentItem.name;
      EventBus().emit('player_content_item', contentItem);
      EventBus().emit('player_content_item_index', playlist.index);
    });

    contentItemIndexChangedSubscription = EventBus()
        .on<int>('player_content_item_index_changed')
        .listen((int index) {
          _player.jump(index);
        });

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getContentTypeDisplayName() {
    switch (widget.contentItem.contentType) {
      case ContentType.liveStream:
        return 'Canlı Yayın';
      case ContentType.vod:
        return 'Film';
      case ContentType.series:
        return 'Dizi';
      default:
        return 'Video';
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        // App arka plana geçti, ses devam etsin
        break;
      case AppLifecycleState.resumed:
        // App ön plana geldi
        break;
      case AppLifecycleState.detached:
        // App kapanıyor, AudioService'i tamamen kapat
        //   AudioServiceManager.instance.stopAudioService();
        break;
      default:
        break;
      // await _audioHandler?.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final isLandscape = screenSize.width > screenSize.height;
    double calculateAspectRatio() {
      if (widget.aspectRatio != null) return widget.aspectRatio!;

      if (isTablet) {
        // Tablet için daha küçük player
        return isLandscape ? 21 / 9 : 16 / 9;
      }
      return 16 / 9;
    }

    // Tablet için maksimum yükseklik belirle
    double? calculateMaxHeight() {
      if (isTablet) {
        if (isLandscape) {
          return screenSize.height * 0.6; // Landscape'de ekranın %60'ı
        } else {
          return screenSize.height * 0.4; // Portrait'te ekranın %40'ı
        }
      }
      return null;
    }


    Widget playerWidget = AspectRatio(
      aspectRatio: calculateAspectRatio(),
      child: isLoading
          ? Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      )
          : _buildPlayerContent(),
    );

    // Tablet için maksimum yükseklik uygula
    if (isTablet) {
      final maxHeight = calculateMaxHeight();
      if (maxHeight != null) {
        playerWidget = ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: playerWidget,
        );
      }
    }

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          playerWidget,
        ],
      ),
    );
  }

  Widget _buildPlayerContent() {
    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    }

    return Stack(
      children: [
        getVideo(context, _videoController!),
        // Custom fullscreen button
        if (widget.onFullscreen != null)
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: widget.onFullscreen,
              icon: const Icon(Icons.fullscreen, color: Colors.white, size: 24),
              style: IconButton.styleFrom(backgroundColor: Colors.black54),
            ),
          ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      String hours = duration.inHours.toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
