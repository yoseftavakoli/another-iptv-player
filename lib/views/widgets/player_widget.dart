import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iptv_player/models/playlist_content_model.dart';
import 'package:media_kit/media_kit.dart' hide Playlist;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:iptv_player/models/playlist_model.dart';

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

Widget getVideo(BuildContext context, VideoController controller) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
      return MaterialVideoControlsTheme(
        normal: MaterialVideoControlsThemeData().copyWith(
          brightnessGesture: false,
          volumeGesture: false,
          seekGesture: false,
        ),
        fullscreen: MaterialVideoControlsThemeData().copyWith(
          brightnessGesture: false,
          volumeGesture: false,
          seekGesture: false,
        ),
        child: Scaffold(body: Video(controller: controller!)),
      );
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
      return MaterialDesktopVideoControlsTheme(
        normal: MaterialDesktopVideoControlsThemeData().copyWith(
          modifyVolumeOnScroll: false,
          toggleFullscreenOnDoublePress: true,
        ),
        fullscreen: MaterialDesktopVideoControlsThemeData().copyWith(
          modifyVolumeOnScroll: false,
          toggleFullscreenOnDoublePress: true,
        ),
        child: Scaffold(body: Video(controller: controller!)),
      );
    default:
      return Video(controller: controller!, controls: NoVideoControls);
  }
}

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
    super.dispose();
  }

  Future<void> _initializeAudioService() async {
    _videoController = VideoController(_player);
    var mediaUrl = buildMediaUrl(widget.playlist, widget.contentItem);
    print('Media URL -> $mediaUrl');
    _player.open(Media(mediaUrl));

    setState(() {
      _isInitialized = true;
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
