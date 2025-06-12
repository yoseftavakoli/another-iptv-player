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
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(height: 16),
                  // Chip(label: Text('Kategori: ${content.}')),
                  SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${content.name} oynatılıyor...'),
                        ),
                      );
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text('Oynat'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
