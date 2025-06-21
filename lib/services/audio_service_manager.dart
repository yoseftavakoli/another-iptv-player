// services/audio_service_manager.dart
import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';

import '../utils/audio_handler.dart';

class AudioServiceManager {
  static AudioServiceManager? _instance;
  static AudioServiceManager get instance => _instance ??= AudioServiceManager._();

  AudioServiceManager._();

  MyAudioHandler? _currentHandler;
  bool _isInitialized = false;

  Future<MyAudioHandler> getAudioHandler() async {
    if (_isInitialized && _currentHandler != null) {
      return _currentHandler!;
    }

    await _initializeAudioService();
    return _currentHandler!;
  }

  Future<void> _initializeAudioService() async {
    if (_isInitialized && _currentHandler != null) return;

    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      _currentHandler = await AudioService.init(
        builder: () => MyAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.yourapp.audio',
          androidNotificationChannelName: 'IPTV Player',
          androidNotificationOngoing: false,
          androidShowNotificationBadge: true,
          androidStopForegroundOnPause: true,
        ),
      );

      _isInitialized = true;
    } catch (e) {
      print('Audio service initialization error: $e');
      _isInitialized = false;
      _currentHandler = null;
      rethrow;
    }
  }


  Future<void> stopAudioService() async {
    try {
      if (_currentHandler != null) {
        await _currentHandler!.stop();
      }
    } catch (e) {
      print('AudioService stop error: $e');
    }
  }

  void reset() {
    _isInitialized = false;
    _currentHandler = null;
  }
}