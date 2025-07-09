import 'package:flutter/material.dart';

import 'xtream-codes/new_xtream_code_playlist_screen.dart';

class PlaylistTypeScreen extends StatelessWidget {
  const PlaylistTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Playlist Oluştur',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Container(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Playlist Türü Seçin',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Oluşturmak istediğiniz playlist türünü seçin',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 40),
                        _buildPlaylistTypeCard(
                          context,
                          title: 'Xtream Codes',
                          subtitle:
                              'API URL, kullanıcı adı ve şifre ile bağlanın',
                          description:
                              'IPTV sağlayıcınızdan aldığınız bilgilerle kolayca bağlanın',
                          icon: Icons.stream,
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewXtreamCodePlaylistScreen(),
                              ),
                            );
                          },
                        ),
                        // SizedBox(height: 20),
                        // _buildPlaylistTypeCard(
                        //   context,
                        //   title: 'M3U Playlist',
                        //   subtitle: 'M3U dosyası veya URL ile playlist ekleyin',
                        //   description:
                        //       'Geleneksel M3U format dosyalarını destekler',
                        //   icon: Icons.playlist_play,
                        //   color: Colors.green,
                        //   onTap: () {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //         content: Row(
                        //           children: [
                        //             Icon(Icons.info, color: Colors.white),
                        //             SizedBox(width: 8),
                        //             Text('M3U özelliği yakında eklenecek'),
                        //           ],
                        //         ),
                        //         backgroundColor: Colors.orange,
                        //       ),
                        //     );
                        //   },
                        // ),
                        Spacer(),
                        // Bu alan büyük ekranlarda genişleyecek
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Playlist bilgileriniz güvenli bir şekilde cihazınızda saklanır.',
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaylistTypeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(icon, size: 30, color: Colors.white),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(fontSize: 13, height: 1.3),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
