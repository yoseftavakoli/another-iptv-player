import 'package:flutter/material.dart';
import 'package:iptv_player/models/playlist_content_model.dart';
import 'package:iptv_player/services/app_state.dart';
import 'package:iptv_player/views/widgets/player_widget.dart';

class ContentDetailScreen extends StatelessWidget {
  final ContentItem content;

  ContentDetailScreen({required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(content.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: content.id,
              child: Container(
                child: PlayerWidget(
                  playlist: AppState.currentPlaylist!,
                  contentItem: content,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
