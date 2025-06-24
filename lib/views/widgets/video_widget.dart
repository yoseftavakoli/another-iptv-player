import 'package:flutter/material.dart';
import 'package:iptv_player/services/player_state.dart';
import 'package:iptv_player/views/widgets/player-buttons/back_button_widget.dart';
import 'package:iptv_player/views/widgets/player-buttons/video_settings_widget.dart';
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
          topButtonBar: [
            BackButtonWidget(),
            Text(PlayerState.title),
            Spacer(),
            VideoSettingsWidget(),
          ],
        ),
        fullscreen: MaterialVideoControlsThemeData().copyWith(
          brightnessGesture: false,
          volumeGesture: false,
          seekGesture: false,
          speedUpOnLongPress: true,
          seekOnDoubleTap: true,
          topButtonBar: [
            BackButtonWidget(),
            Text(PlayerState.title),
            Spacer(),
            VideoSettingsWidget(),
          ],
        ),
        child: Scaffold(
          body: Video(
            controller: controller!,
            resumeUponEnteringForegroundMode: true,
            pauseUponEnteringBackgroundMode: false,
          ),
        ),
      );
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
      return MaterialDesktopVideoControlsTheme(
        normal: MaterialDesktopVideoControlsThemeData().copyWith(
          modifyVolumeOnScroll: false,
          toggleFullscreenOnDoublePress: true,
          topButtonBar: [
            BackButtonWidget(),
            Text(PlayerState.title),
            Spacer(),
            VideoSettingsWidget(),
          ],
        ),
        fullscreen: MaterialDesktopVideoControlsThemeData().copyWith(
          modifyVolumeOnScroll: false,
          toggleFullscreenOnDoublePress: true,
          topButtonBar: [
            BackButtonWidget(),
            Text(PlayerState.title),
            Spacer(),
            VideoSettingsWidget(),
          ],
        ),
        child: Scaffold(
          body: Video(
            controller: controller!,
            resumeUponEnteringForegroundMode: true,
            pauseUponEnteringBackgroundMode: false,
          ),
        ),
      );
    default:
      return Video(
        controller: controller!,
        controls: NoVideoControls,
        resumeUponEnteringForegroundMode: true,
        pauseUponEnteringBackgroundMode: false,
      );
  }
}
