import 'package:media_kit/media_kit.dart';

abstract class PlayerState {
  static late List<VideoTrack> videos;
  static late VideoTrack selectedVideo;
  
  static late List<AudioTrack> audios;
  static late AudioTrack selectedAudio;

  static late List<SubtitleTrack> subtitles;
  static late SubtitleTrack selectedSubtitle;
}
