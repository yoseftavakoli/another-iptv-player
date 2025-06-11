import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:iptv_player/models/playlist_content_model.dart';
import 'package:media_kit/media_kit.dart' hide Playlist;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:iptv_player/models/playlist_model.dart';

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

class _PlayerWidgetState extends State<PlayerWidget> {
  Player? player; // late yerine nullable yaptık
  VideoController? controller; // late yerine nullable yaptık
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  bool isDisposed = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    MediaKit.ensureInitialized();
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    if (isDisposed) return; // Widget dispose edilmişse işlemi durdur

    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      // Player'ları oluştur
      final newPlayer = Player();
      final newController = VideoController(newPlayer);

      // Widget hala mount edilmiş mi kontrol et
      if (!mounted || isDisposed) {
        newPlayer.dispose();
        return;
      }

      setState(() {
        player = newPlayer;
        controller = newController;
      });

      // Media URL'ini oluştur
      String mediaUrl = _buildMediaUrl();
      print("MEDIA URL:" + mediaUrl);

      await player!.open(
        Media(
          mediaUrl,
          extras: {
            'track': '9',
            'year': '2012',
            'title': 'Courtesy Call',
            'artist': 'Thousand Foot Krutch',
            'album': 'The End Is Where We Begin',
          },
        ),
      );

      player?.stream.tracks.listen((event) {
        List<VideoTrack> videos = event.video;
        List<AudioTrack> audios = event.audio;
        List<SubtitleTrack> subtitles = event.subtitle;

        audios.forEach((video) {
          print("TRACK -> VIDEO -> ${video.title}");
        });

        audios.forEach((audio) {
          print("TRACK -> AUDIO -> ${audio.title}");
        });

        subtitles.forEach((subtitle) {
          print("TRACK -> SUBTITLE -> ${subtitle.title}");
        });
      });

      // Media'yı yükle
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration.music());

      if (await session.setActive(true)) {
        // Now play audio.
      } else {
        // The request was denied and the app should not play audio
      }

      // Widget hala mount edilmiş mi kontrol et
      if (!mounted || isDisposed) {
        return;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted || isDisposed) return;

      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Player başlatılırken hata oluştu: $e';
      });
    }
  }

  String _buildMediaUrl() {
    switch (widget.contentItem.contentType) {
      case ContentType.liveStream:
        return '${widget.playlist.url}/${widget.playlist.username}/${widget.playlist.password}/${widget.contentItem.id}';
      case ContentType.vod:
        return '${widget.playlist.url}/movie/${widget.playlist.username}/${widget.playlist.password}/${widget.contentItem.id}.${widget.contentItem.containerExtension!}';
      case ContentType.series:
        return '2';
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    player?.dispose();
    super.dispose();
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

          // Info Section (opsiyonel)
          if (widget.showInfo && player != null) _buildInfoSection(),
        ],
      ),
    );
  }

  Widget _buildPlayerContent() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 8),
            Text(
              'Yükleniyor...',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      );
    }

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
            ElevatedButton(
              onPressed: _initializePlayer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    // Player ve controller null kontrolü
    if (player == null || controller == null) {
      return const Center(
        child: Text(
          'Player başlatılıyor...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Stack(
      children: [
        Video(
          controller: controller!,
          controls: widget.showControls
              ? AdaptiveVideoControls
              : NoVideoControls,
        ),

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

  Widget _buildInfoSection() {
    // Player null kontrolü
    if (player == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.black87,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getTypeIcon(), color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Text(
                widget.contentItem.contentType.toString().toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              StreamBuilder<Duration>(
                stream: player!.stream.position,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = player!.state.duration ?? Duration.zero;

                  return Text(
                    '${_formatDuration(position)} / ${_formatDuration(duration)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'ID: ${widget.contentItem.id}',
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (widget.contentItem.contentType.toString().toLowerCase()) {
      case 'stream':
        return Icons.live_tv;
      case 'vod':
        return Icons.movie;
      case 'series':
        return Icons.tv;
      default:
        return Icons.play_circle;
    }
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
