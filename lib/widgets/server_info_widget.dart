import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/api_response.dart';
import 'info_tile_widget.dart';
import 'section_title_widget.dart';

class ServerInfoWidget extends StatelessWidget {
  final ApiResponse serverInfo;

  const ServerInfoWidget({super.key, required this.serverInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(title: 'Server Bilgileri'),
        Card(
          child: Column(
            children: [
              InfoTileWidget(
                icon: Icons.public,
                label: 'Server URL',
                value: serverInfo.serverInfo.url,
              ),
              InfoTileWidget(
                icon: Icons.access_time,
                label: 'Saat Dilimi',
                value: serverInfo.serverInfo.timezone ?? 'Bilinmiyor',
              ),
              InfoTileWidget(
                icon: Icons.message,
                label: 'Server Mesajı',
                value: serverInfo.userInfo.message ?? 'Mesaj yok',
              ),
            ],
          ),
        ),
      ],
    );
  }
}