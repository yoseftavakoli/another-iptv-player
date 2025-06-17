import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iptv_player/services/event_bus.dart';
import 'package:iptv_player/services/player_state.dart';
import 'package:media_kit/media_kit.dart' hide PlayerState;

class VideoSettingsWidget extends StatefulWidget {
  const VideoSettingsWidget({super.key});

  @override
  State<VideoSettingsWidget> createState() => _VideoSettingsWidgetState();
}

class _VideoSettingsWidgetState extends State<VideoSettingsWidget> {
  late StreamSubscription subscription;
  late List<VideoTrack> videoTracks;
  late List<AudioTrack> audioTracks;
  late List<SubtitleTrack> subtitleTracks;

  late String selectedVideoTrack;
  late String selectedAudioTrack;
  late String selectedSubtitleTrack;

  @override
  void initState() {
    super.initState();

    videoTracks = PlayerState.videos;
    audioTracks = PlayerState.audios;
    subtitleTracks = PlayerState.subtitles;

    selectedVideoTrack = PlayerState.selectedVideo.title ?? 'Empty';
    selectedAudioTrack = PlayerState.selectedAudio.language ?? 'Empty';
    selectedSubtitleTrack = PlayerState.selectedSubtitle.language ?? 'Empty';

    subscription = EventBus().on<Tracks>('player_tracks').listen((Tracks data) {
      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          print('player_tracks' + data.toString());
          videoTracks = data.video;
          audioTracks = data.audio;
          subtitleTracks = data.subtitle;
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription to prevent memory leaks and setState calls after dispose
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () => _showSettingsBottomSheet(context),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildSettingsItem(
                icon: Icons.video_settings,
                title: 'Video Track',
                subtitle: selectedVideoTrack,
                onTap: () => _showVideoTrackSelection(context),
              ),
              _buildSettingsItem(
                icon: Icons.audiotrack,
                title: 'Audio Track',
                subtitle: selectedAudioTrack,
                onTap: () => _showAudioTrackSelection(context),
              ),
              _buildSettingsItem(
                icon: Icons.subtitles,
                title: 'Subtitles Track',
                subtitle: selectedSubtitleTrack,
                onTap: () => _showSubtitleTrackSelection(context),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showVideoTrackSelection(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                      _showSettingsBottomSheet(context);
                    },
                  ),
                  Text(
                    'Video Quality',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ...videoTracks
                  .map(
                    (track) => ListTile(
                      title: Text(track.id),
                      trailing: selectedVideoTrack == track.id
                          ? Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        EventBus().emit('video_track_changed', track);

                        if (mounted) {
                          setState(() {
                            selectedVideoTrack = track.id;
                          });
                        }
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showAudioTrackSelection(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                      _showSettingsBottomSheet(context);
                    },
                  ),
                  Text(
                    'Audio Language',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ...audioTracks
                  .map(
                    (track) => ListTile(
                      title: Text(track.language ?? 'NULL'),
                      trailing: selectedAudioTrack == (track.language ?? 'NULL')
                          ? Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        EventBus().emit('audio_track_changed', track);

                        if (mounted) {
                          setState(() {
                            selectedAudioTrack = track.language ?? 'NULL';
                          });
                        }
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showSubtitleTrackSelection(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                      _showSettingsBottomSheet(context);
                    },
                  ),
                  Text(
                    'Subtitles',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ...subtitleTracks
                  .map(
                    (track) => ListTile(
                      title: Text(track.language ?? 'NULL'),
                      trailing:
                          selectedSubtitleTrack == (track.language ?? 'NULL')
                          ? Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        EventBus().emit('subtitle_track_changed', track);

                        if (mounted) {
                          setState(() {
                            selectedSubtitleTrack = track.language ?? 'NULL';
                          });
                        }
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
