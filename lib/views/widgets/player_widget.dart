import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iptv_player/models/playlist_content_model.dart';
import 'package:iptv_player/repositories/user_prefrences.dart';
import 'package:iptv_player/services/event_bus.dart';
import 'package:iptv_player/views/widgets/video_widget.dart';
import 'package:media_kit/media_kit.dart' hide Playlist, PlayerState;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:iptv_player/models/playlist_model.dart';
import '../../services/player_state.dart';

class PlayerWidget extends StatefulWidget {
  final Playlist playlist;
  final ContentItem contentItem;
  final double? aspectRatio;
  final bool showControls;
  final bool showInfo;
  final VoidCallback? onFullscreen;

  const PlayerWidget({
    Key? key,
    required this.playlist,
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

  final Player _player = Player(configuration: PlayerConfiguration(osc: false));
  VideoController? _videoController;

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  bool _isInitialized = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _initializeAudioService();
  }

  @override
  void dispose() {
    _player.dispose();
    videoTrackSubscription.cancel();
    audioTrackSubscription.cancel();
    subtitleTranckSubscription.cancel();
    super.dispose();
  }

  Future<void> _initializeAudioService() async {
    _videoController = VideoController(_player);
    var mediaUrl = buildMediaUrl(widget.playlist, widget.contentItem);
    _player.open(Media(mediaUrl));
    _player.setVideoTrack(VideoTrack.auto());
    _player.setAudioTrack(AudioTrack.auto());
    _player.setSubtitleTrack(SubtitleTrack.auto());

    setState(() {
      _isInitialized = true;
    });

    videoTrackSubscription = EventBus()
        .on<VideoTrack>('video_track_changed')
        .listen((VideoTrack data) {
          setState(() async {
            _player.setVideoTrack(data);
            await UserPreferences.setVideoTrack(data.id);
          });
        });

    audioTrackSubscription = EventBus()
        .on<AudioTrack>('audio_track_changed')
        .listen((AudioTrack data) {
          setState(() async {
            _player.setAudioTrack(data);
            await UserPreferences.setAudioTrack(data.language ?? 'null');
          });
        });

    subtitleTranckSubscription = EventBus()
        .on<SubtitleTrack>('subtitle_track_changed')
        .listen((SubtitleTrack data) {
          setState(() async {
            _player.setSubtitleTrack(data);
            await UserPreferences.setSubtitleTrack(data.language ?? 'null');
          });
        });

    _player.stream.tracks.listen((event) async {
      PlayerState.videos = event.video;
      PlayerState.audios = event.audio;
      PlayerState.subtitles = event.subtitle;

      EventBus().emit('player_tracks', event);

      await _player.setVideoTrack(
        VideoTrack(await UserPreferences.getVideoTrack(), null, null),
      );

      var selectedAudioLanguage = await UserPreferences.getAudioTrack();
      var possibleAudioTrack = event.audio.firstWhere((x) {
        return x.language == selectedAudioLanguage;
      });

      if (possibleAudioTrack != null) {
        await _player.setAudioTrack(possibleAudioTrack);
      }

      var selectedSubtitleLanguage = await UserPreferences.getSubtitleTrack();
      var possibleSubtitleLanguage = event.subtitle.firstWhere((x) {
        return x.language == selectedSubtitleLanguage;
      });

      if (possibleSubtitleLanguage != null) {
        await _player.setSubtitleTrack(possibleSubtitleLanguage);
      }
    });

    _player.stream.track.listen((event) {
      PlayerState.selectedVideo = _player.state.track.video;
      PlayerState.selectedAudio = _player.state.track.audio;
      PlayerState.selectedSubtitle = _player.state.track.subtitle;
    });
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
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Video Player Container
          AspectRatio(
            aspectRatio: widget.aspectRatio ?? 16 / 9,
            child: _buildPlayerContent(),
          ),
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
        if (_isInitialized) getVideo(context, _videoController!),
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

String buildMediaUrl(Playlist playlist, ContentItem contentItem) {
  switch (contentItem.contentType) {
    case ContentType.liveStream:
      return '${playlist.url}/${playlist.username}/${playlist.password}/${contentItem.id}';
    case ContentType.vod:
      return '${playlist.url}/movie/${playlist.username}/${playlist.password}/${contentItem.id}.${contentItem.containerExtension!}';
    case ContentType.series:
      return '${playlist.url}/series/${playlist.username}/${playlist.password}/${contentItem.id}.${contentItem.containerExtension!}';
  }
}
