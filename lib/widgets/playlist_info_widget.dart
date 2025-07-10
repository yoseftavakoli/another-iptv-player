import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/playlist_model.dart';
import 'section_title_widget.dart';
import 'info_tile_widget.dart';

class PlaylistInfoWidget extends StatelessWidget {
  final Playlist playlist;

  const PlaylistInfoWidget({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(title: 'Playlist Bilgileri'),
        Card(
          child: Column(
            children: [
              InfoTileWidget(
                icon: Icons.label_outline,
                label: 'Playlist Adı',
                value: playlist.name ?? 'Bilinmiyor',
              ),
              InfoTileWidget(
                icon: Icons.link,
                label: 'Sunucu URL',
                value: playlist.url ?? 'Bilinmiyor',
              ),
              InfoTileWidget(
                icon: Icons.person,
                label: 'Kullanıcı Adı',
                value: playlist.username ?? 'Bilinmiyor',
              ),
            ],
          ),
        ),
      ],
    );
  }
}