import 'package:flutter/material.dart';
import 'package:iptv_player/models/playlist_content_model.dart';
import 'package:iptv_player/views/widgets/player_widget.dart';
import 'package:media_kit/media_kit.dart' hide Playlist;
import 'package:iptv_player/models/playlist_model.dart';

class FullscreenPlayerScreen extends StatelessWidget {
  final Playlist playlist;
  final ContentItem contentItem;

  const FullscreenPlayerScreen({
    Key? key,
    required this.playlist,
    required this.contentItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PlayerWidget(
          playlist: playlist,
          contentItem: contentItem,
          aspectRatio:
              MediaQuery.of(context).size.width /
              MediaQuery.of(context).size.height,
        ),
      ),
    );
  }
}
