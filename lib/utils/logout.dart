import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:another_iptv_player/controllers/playlist_controller.dart';
import 'package:another_iptv_player/screens/xtream-codes/new_xtream_code_playlist_screen.dart';

Future<void> handleLogout(BuildContext context) async {
  final controller = Provider.of<PlaylistController>(context, listen: false);

  // Remove all saved playlists/creds (adjust if your controller exposes clearAll())
  try {
    final items = List.of(controller.playlists);
    for (final p in items) {
      await controller.deletePlaylist(p.id);
    }
  } catch (_) {
    // If the controller has a clearAll(), use that instead:
    // await controller.clearAll();
  }

  // Send user back to the username/password screen, clearing history
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const NewXtreamCodePlaylistScreen()),
    (route) => false,
  );
}
