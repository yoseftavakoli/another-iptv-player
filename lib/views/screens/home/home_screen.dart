// views/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:iptv_player/services/app_state.dart';
import 'package:iptv_player/views/screens/home/iptv_home_screen.dart';
import 'package:provider/provider.dart';
import '../../../controllers/playlist_controller.dart';
import '../../../models/playlist_model.dart';
import '../playlist/playlist_type_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlaylistController>(context, listen: false).loadPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Playlistlerim',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<PlaylistController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Playlistler yükleniyor...'),
                ],
              ),
            );
          }

          if (controller.error != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Hata Oluştu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      controller.error!,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => controller.loadPlaylists(),
                      icon: Icon(Icons.refresh),
                      label: Text('Tekrar Dene'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.playlists.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => controller.loadPlaylists(),
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: controller.playlists.length,
              itemBuilder: (context, index) {
                final playlist = controller.playlists[index];
                return _buildPlaylistCard(playlist, controller);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePlaylist,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Yeni Playlist Oluştur',
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.playlist_add, size: 80, color: Colors.grey[400]),
            SizedBox(height: 24),
            Text(
              'Henüz Playlist Yok',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'İlk playlist\'inizi oluşturarak başlayın.\nXStream Code veya M3U formatında\nplaylist ekleyebilirsiniz.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _navigateToCreatePlaylist,
              icon: Icon(Icons.add),
              label: Text('İlk Playlist\'imi Oluştur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistCard(Playlist playlist, PlaylistController controller) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _openPlaylist(playlist),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getPlaylistColor(playlist.type),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  _getPlaylistIcon(playlist.type),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getPlaylistColor(
                              playlist.type,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            playlist.type
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getPlaylistColor(playlist.type),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.access_time, size: 12, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          _formatDate(playlist.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    if (playlist.url != null) ...[
                      SizedBox(height: 4),
                      Text(
                        playlist.url!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Düzenle'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Sil', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteDialog(controller, playlist);
                  } else if (value == 'edit') {
                    _editPlaylist(playlist);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPlaylistColor(PlaylistType type) {
    switch (type) {
      case PlaylistType.xstream:
        return Colors.blue;
      case PlaylistType.m3u:
        return Colors.green;
    }
  }

  IconData _getPlaylistIcon(PlaylistType type) {
    switch (type) {
      case PlaylistType.xstream:
        return Icons.stream;
      case PlaylistType.m3u:
        return Icons.playlist_play;
    }
  }

  void _navigateToCreatePlaylist() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlaylistTypeScreen()),
    );
  }

  void _openPlaylist(Playlist playlist) {
    AppState.currentPlaylist = playlist;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => IPTVHomeScreen(playlist: playlist),
        // builder: (context) => PlaylistContentScreen(playlist: playlist),
      ),
    );
  }

  void _editPlaylist(Playlist playlist) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${playlist.name} düzenleme özelliği yakında...'),
        duration: Duration(seconds: 1),
      ),
    );
    // TODO: Playlist düzenleme sayfasına yönlendir
  }

  void _showDeleteDialog(PlaylistController controller, Playlist playlist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Playlist\'i Sil'),
        content: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black87),
            children: [
              TextSpan(text: '"'),
              TextSpan(
                text: playlist.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    '" playlist\'ini silmek istediğinizden emin misiniz?\n\nBu işlem geri alınamaz.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await controller.deletePlaylist(playlist.id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${playlist.name} silindi'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Sil'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}
