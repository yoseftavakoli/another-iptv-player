import 'package:flutter/material.dart';
import 'package:iptv_player/views/widgets/player_widget.dart';
import 'package:iptv_player/views/widgets/video_settings_widget.dart';
import 'package:media_kit_video/media_kit_video.dart';

Widget getVideo(BuildContext context, VideoController controller) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
      return MaterialVideoControlsTheme(
        normal: MaterialVideoControlsThemeData().copyWith(
          brightnessGesture: false,
          volumeGesture: false,
          seekGesture: false,
          speedUpOnLongPress: true,
          seekOnDoubleTap: true,
        ),
        fullscreen: MaterialVideoControlsThemeData().copyWith(
          brightnessGesture: false,
          volumeGesture: false,
          seekGesture: false,
          speedUpOnLongPress: true,
          seekOnDoubleTap: true,
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
          topButtonBar: [VideoSettingsWidget()],
        ),
        fullscreen: MaterialDesktopVideoControlsThemeData().copyWith(
          modifyVolumeOnScroll: false,
          toggleFullscreenOnDoublePress: true,
          topButtonBar: [VideoSettingsWidget()],
        ),
        child: Scaffold(body: Video(controller: controller!)),
      );
    default:
      return Video(controller: controller!, controls: NoVideoControls);
  }
}
