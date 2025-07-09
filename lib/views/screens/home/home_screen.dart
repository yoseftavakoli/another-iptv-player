import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../database/playlist_controller.dart';
import '../../../models/playlist_model.dart';
import '../playlist/playlist_type_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlaylistController(),
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final controller = context.read<PlaylistController>();
            if (!controller.isLoading &&
                controller.playlists.isEmpty &&
                controller.error == null) {
              controller.initializeApp(
                context,
              );
            }
          });

          return Scaffold(
            appBar: _buildAppBar(),
            body: Consumer<PlaylistController>(
              builder: (context, controller, child) => _buildBody(controller),
            ),
            floatingActionButton: _buildFloatingActionButton(),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Playlistlerim',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBody(PlaylistController controller) {
    if (controller.isLoading) {
      return _buildLoadingState();
    }

    if (controller.error != null) {
      return _buildErrorState(controller);
    }

    if (controller.playlists.isEmpty) {
      return _buildEmptyState();
    }

    return _buildPlaylistList(controller);
  }

  Widget _buildLoadingState() {
    return const Center(
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

  Widget _buildErrorState(PlaylistController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Hata Oluştu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              controller.error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.loadPlaylists(context),
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.playlist_add, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Henüz Playlist Yok',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'İlk playlist\'inizi oluşturarak başlayın.\nXStream Code veya M3U formatında\nplaylist ekleyebilirsiniz.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _navigateToCreatePlaylist,
              icon: const Icon(Icons.add),
              label: const Text('İlk Playlist\'imi Oluştur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistList(PlaylistController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.loadPlaylists(context),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.playlists.length,
        itemBuilder: (context, index) {
          return _buildPlaylistCard(controller.playlists[index], controller);
        },
      ),
    );
  }

  Widget _buildPlaylistCard(Playlist playlist, PlaylistController controller) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.openPlaylist(context, playlist),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildPlaylistIcon(playlist.type),
              const SizedBox(width: 16),
              Expanded(child: _buildPlaylistInfo(playlist)),
              _buildPlaylistMenu(controller, playlist),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistIcon(PlaylistType type) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: _getPlaylistColor(type),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Icon(_getPlaylistIcon(type), color: Colors.white, size: 24),
    );
  }

  Widget _buildPlaylistInfo(Playlist playlist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playlist.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _buildTypeChip(playlist.type),
            const SizedBox(width: 8),
            const Icon(Icons.access_time, size: 12, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              _formatDate(playlist.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        if (playlist.url != null) ...[
          const SizedBox(height: 4),
          Text(
            playlist.url!,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildTypeChip(PlaylistType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getPlaylistColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.toString().split('.').last.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _getPlaylistColor(type),
        ),
      ),
    );
  }

  Widget _buildPlaylistMenu(PlaylistController controller, Playlist playlist) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        const PopupMenuItem(
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
        }
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _navigateToCreatePlaylist,
      tooltip: 'Yeni Playlist Oluştur',
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Color _getPlaylistColor(PlaylistType type) {
    return switch (type) {
      PlaylistType.xstream => Colors.blue,
      PlaylistType.m3u => Colors.green,
    };
  }

  IconData _getPlaylistIcon(PlaylistType type) {
    return switch (type) {
      PlaylistType.xstream => Icons.stream,
      PlaylistType.m3u => Icons.playlist_play,
    };
  }

  void _navigateToCreatePlaylist() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlaylistTypeScreen()),
    );
  }

  void _showDeleteDialog(PlaylistController controller, Playlist playlist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Playlist\'i Sil'),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87),
            children: [
              const TextSpan(text: '"'),
              TextSpan(
                text: playlist.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text:
                    '" playlist\'ini silmek istediğinizden emin misiniz?\n\nBu işlem geri alınamaz.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await controller.deletePlaylist(playlist.id);
              if (success && mounted) {
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
            child: const Text('Sil'),
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
