import 'package:media_kit/media_kit.dart';

abstract class PlayerState {
  static List<VideoTrack> videos = [];
  static VideoTrack selectedVideo = VideoTrack.auto();

  static List<AudioTrack> audios = [];
  static AudioTrack selectedAudio = AudioTrack.auto();

  static List<SubtitleTrack> subtitles = [];
  static SubtitleTrack selectedSubtitle = SubtitleTrack.auto();

  static String title = '';
}
