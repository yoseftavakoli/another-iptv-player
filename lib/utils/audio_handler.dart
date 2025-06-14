import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/gestures.dart';
import 'package:iptv_player/services/service_locator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

Future<MediaKitAudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MediaKitAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class MediaKitAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final Player _player = Player();
  VideoController? _videoController;

  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController =
      StreamController<Duration>.broadcast();
  final StreamController<bool> _playingController =
      StreamController<bool>.broadcast();

  Timer? _positionTimer;

  IptvAudioHandler() {
    _init();
  }

  void _init() {
    _videoController = VideoController(_player);

    // Player event listeners
    _player.stream.playing.listen((playing) {
      _playingController.add(playing);
      _updatePlaybackState();
    });

    _player.stream.duration.listen((duration) {
      _durationController.add(duration);
    });

    _player.stream.position.listen((position) {
      _positionController.add(position);
    });

    _player.stream.completed.listen((completed) {
      if (completed) {
        _onMediaCompleted();
      }
    });

    // Position timer for more frequent updates
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_player.state.playing) {
        _positionController.add(_player.state.position);
      }
    });
  }

  // Getter'lar
  Player get player => _player;
  VideoController? get videoController => _videoController;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<bool> get playingStream => _playingController.stream;

  // Media bilgilerini set etme
  Future<void> setMediaItem(MediaItem mediaItem) async {
    this.mediaItem.add(mediaItem);
    await _updatePlaybackState();
  }

  // IPTV kanalını oynatma
  Future<void> playChannel({
    required String url,
    required String title,
    String? artist,
    String? album,
    String? artUri,
    String? genre,
    Map<String, String>? extras,
  }) async {
    try {
      final mediaItem = MediaItem(
        id: url,
        title: title,
        artist: artist ?? 'IPTV Channel',
        album: album ?? 'Live TV',
        artUri: artUri != null ? Uri.parse(artUri) : null,
        genre: genre ?? 'Television',
        extras: extras ?? {},
        duration: Duration.zero, // Live stream için duration sıfır
      );

      await setMediaItem(mediaItem);

      // Media Kit ile URL'yi oynat
      await _player.open(Media(url));
      await _player.play();
    } catch (e) {
      print('Kanal oynatma hatası: $e');
      rethrow;
    }
  }

  // VOD (Video on Demand) oynatma
  Future<void> playVod({
    required String url,
    required String title,
    String? artist,
    String? album,
    String? artUri,
    Duration? duration,
    Map<String, String>? extras,
  }) async {
    try {
      final mediaItem = MediaItem(
        id: url,
        title: title,
        artist: artist ?? 'VOD',
        album: album ?? 'Movies & Series',
        artUri: artUri != null ? Uri.parse(artUri) : null,
        duration: duration,
        extras: extras ?? {},
      );

      await setMediaItem(mediaItem);

      await _player.open(Media(url));
      await _player.play();
    } catch (e) {
      print('VOD oynatma hatası: $e');
      rethrow;
    }
  }

  // AudioHandler override metodları
  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await _updatePlaybackState();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume * 100); // Media Kit 0-100 arası değer alır
  }

  @override
  Future<void> setSpeed(double speed) async {
    await _player.setRate(speed);
  }

  // Playlist yönetimi
  @override
  Future<void> skipToNext() async {
    // Sonraki kanal/video mantığı
    if (queue.value.isNotEmpty) {
      final currentIndex = queue.value.indexWhere(
        (item) => item.id == mediaItem.value?.id,
      );
      if (currentIndex >= 0 && currentIndex < queue.value.length - 1) {
        final nextItem = queue.value[currentIndex + 1];
        await playChannel(
          url: nextItem.id,
          title: nextItem.title,
          artist: nextItem.artist,
          album: nextItem.album,
          artUri: nextItem.artUri?.toString(),
        );
      }
    }
  }

  @override
  Future<void> skipToPrevious() async {
    // Önceki kanal/video mantığı
    if (queue.value.isNotEmpty) {
      final currentIndex = queue.value.indexWhere(
        (item) => item.id == mediaItem.value?.id,
      );
      if (currentIndex > 0) {
        final previousItem = queue.value[currentIndex - 1];
        await playChannel(
          url: previousItem.id,
          title: previousItem.title,
          artist: previousItem.artist,
          album: previousItem.album,
          artUri: previousItem.artUri?.toString(),
        );
      }
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index >= 0 && index < queue.value.length) {
      final item = queue.value[index];
      await playChannel(
        url: item.id,
        title: item.title,
        artist: item.artist,
        album: item.album,
        artUri: item.artUri?.toString(),
      );
    }
  }

  // Playlist güncelleme
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    queue.add(newQueue);
  }

  // Custom metodlar
  Future<void> setSubtitles(String subtitleUrl) async {
    // Subtitle ekleme mantığı
    await _player.setSubtitleTrack(SubtitleTrack.uri(subtitleUrl));
  }

  Future<void> setAudioTrack(int trackIndex) async {
    // Audio track değiştirme
    final tracks = _player.state.tracks.audio;
    if (trackIndex >= 0 && trackIndex < tracks.length) {
      await _player.setAudioTrack(tracks[trackIndex]);
    }
  }

  Future<void> setVideoQuality(int qualityIndex) async {
    // Video kalite değiştirme
    final tracks = _player.state.tracks.video;
    if (qualityIndex >= 0 && qualityIndex < tracks.length) {
      await _player.setVideoTrack(tracks[qualityIndex]);
    }
  }

  // Playback state güncelleme
  Future<void> _updatePlaybackState() async {
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          _player.state.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: _getProcessingState(),
        playing: _player.state.playing,
        updatePosition: _player.state.position,
        bufferedPosition: _player.state.buffer,
        speed: _player.state.rate,
        queueIndex: _getCurrentQueueIndex(),
      ),
    );
  }

  AudioProcessingState _getProcessingState() {
    if (_player.state.buffering) {
      return AudioProcessingState.buffering;
    } else if (_player.state.completed) {
      return AudioProcessingState.completed;
    } else {
      return AudioProcessingState.ready;
    }
  }

  int? _getCurrentQueueIndex() {
    if (mediaItem.value == null) return null;
    return queue.value.indexWhere((item) => item.id == mediaItem.value!.id);
  }

  void _onMediaCompleted() {
    // Media tamamlandığında sonraki öğeye geç
    skipToNext();
  }

  // Kaynak temizleme
  @override
  Future<void> onTaskRemoved() async {
    await stop();
    await super.onTaskRemoved();
  }

  Future<void> dispose() async {
    _positionTimer?.cancel();
    await _positionController.close();
    await _durationController.close();
    await _playingController.close();
    await _player.dispose();
  }
}
