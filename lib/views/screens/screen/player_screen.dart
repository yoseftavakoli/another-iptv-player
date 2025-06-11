import 'package:flutter/material.dart';
import 'package:iptv_player/models/playlist_content_model.dart';
import 'package:iptv_player/models/playlist_model.dart';
import 'package:iptv_player/views/screens/screen/full_screen_player_screen.dart';
import 'package:iptv_player/views/widgets/player_widget.dart';

class PlayerScreen extends StatelessWidget {
  final Playlist playlist;
  final ContentItem contentItem;

  const PlayerScreen({
    Key? key,
    required this.playlist,
    required this.contentItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('Player', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PlayerWidget(
        playlist: playlist,
        contentItem: contentItem,
        showInfo: true,
        onFullscreen: () {
          // Fullscreen logic
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullscreenPlayerScreen(
                playlist: playlist,
                contentItem: contentItem,
              ),
            ),
          );
        },
      ),
    );
  }
}
