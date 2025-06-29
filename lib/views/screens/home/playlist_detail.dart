import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/api_response.dart';
import 'package:another_iptv_player/models/playlist_model.dart';
import 'package:another_iptv_player/repositories/user_prefrences.dart';
import 'package:another_iptv_player/services/app_state.dart';
import 'package:another_iptv_player/views/screens/home/home_screen.dart';
import 'package:another_iptv_player/views/screens/playlist/progress_loading_screen.dart';

class PlaylistSettingsScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistSettingsScreen({super.key, required this.playlist});

  @override
  _PlaylistSettingsScreenState createState() => _PlaylistSettingsScreenState();
}

class _PlaylistSettingsScreenState extends State<PlaylistSettingsScreen>
    with SingleTickerProviderStateMixin {
  bool _isRefreshing = false;
  ApiResponse? _serverInfo;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadServerInfo();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadServerInfo() async {
    try {
      if (AppState.repository != null) {
        final info = await AppState.repository!.getPlayerInfo();
        if (mounted) {
          setState(() {
            _serverInfo = info;
          });
        }
      }
    } catch (e) {
      print('Server bilgileri yüklenemedi: $e');
    }
  }

  Future<void> _refreshContent() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProgressLoadingScreen(
            playlist: AppState.currentPlaylist!,
            refreshAll: true,
          ),
        ),
      );
    } catch (e) {
      print('İçerik yenileme hatası: $e');
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  String _getRemainingDays() {
    if (_serverInfo?.userInfo.expDate != null) {
      final expDate = _serverInfo!.userInfo.expDate;
      try {
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(expDate.toString()) * 1000,
        );
        final now = DateTime.now();
        final difference = expiryDate.difference(now).inDays;
        return difference > 0 ? '$difference gün' : 'Süresi dolmuş';
      } catch (e) {
        print('Tarih hesaplama hatası: $e');
        return 'Bilinmiyor';
      }
    }
    return 'Bilinmiyor';
  }

  String _getServerStatus() {
    return _serverInfo != null ? 'Bağlı' : 'Bağlantı yok';
  }

  Color _getStatusColor() {
    if (_serverInfo != null) {
      final remaining = _getRemainingDays();
      if (remaining == 'Süresi dolmuş') return Colors.red;
      if (remaining.contains('gün')) {
        final days = int.tryParse(remaining.split(' ')[0]) ?? 0;
        if (days <= 7) return Colors.orange;
        return Colors.green;
      }
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Playlist Ayarları',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Status Overview Card
                    _buildStatusOverviewCard(),
                    
                    const SizedBox(height: 20),
                    
                    // Playlist Info
                    _buildModernSectionCard(
                      title: 'Playlist Bilgileri',
                      icon: Icons.playlist_play_rounded,
                      iconColor: Colors.blue,
                      children: [
                        _buildModernInfoTile(
                          Icons.label_outline,
                          'Playlist Adı',
                          widget.playlist.name ?? 'Bilinmiyor',
                        ),
                        _buildModernInfoTile(
                          Icons.link_rounded,
                          'Sunucu URL',
                          widget.playlist.url ?? 'Bilinmiyor',
                          isUrl: true,
                        ),
                        _buildModernInfoTile(
                          Icons.person_outline,
                          'Kullanıcı Adı',
                          widget.playlist.username ?? 'Bilinmiyor',
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Subscription Info
                    _buildModernSectionCard(
                      title: 'Abonelik Detayları',
                      icon: Icons.card_membership_rounded,
                      iconColor: Colors.purple,
                      children: [
                        _buildModernInfoTile(
                          Icons.schedule_rounded,
                          'Kalan Süre',
                          _getRemainingDays(),
                          valueColor: _getStatusColor(),
                        ),
                        if (_serverInfo?.userInfo != null) ...[
                          _buildModernInfoTile(
                            Icons.devices_rounded,
                            'Aktif Bağlantı',
                            _serverInfo!.userInfo.activeCons.toString() ?? '0',
                          ),
                          _buildModernInfoTile(
                            Icons.device_hub_rounded,
                            'Maksimum Bağlantı',
                            _serverInfo!.userInfo.maxConnections.toString() ?? 'Bilinmiyor',
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Server Info
                    if (_serverInfo?.serverInfo != null)
                      _buildModernSectionCard(
                        title: 'Server Bilgileri',
                        icon: Icons.dns_rounded,
                        iconColor: Colors.green,
                        children: [
                          _buildModernInfoTile(
                            Icons.public_rounded,
                            'Server URL',
                            _serverInfo!.serverInfo.url,
                            isUrl: true,
                          ),
                          _buildModernInfoTile(
                            Icons.access_time_rounded,
                            'Saat Dilimi',
                            _serverInfo!.serverInfo.timezone ?? 'Bilinmiyor',
                          ),
                          _buildModernInfoTile(
                            Icons.message_rounded,
                            'Server Mesajı',
                            _serverInfo!.userInfo.message ?? 'Mesaj yok',
                          ),
                        ],
                      ),

                    const SizedBox(height: 30),

                    // Action Buttons
                    _buildModernActionButtons(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getStatusColor().withOpacity(0.1),
            _getStatusColor().withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            _getStatusColor() == Colors.green 
                ? Icons.check_circle_rounded
                : _getStatusColor() == Colors.orange
                    ? Icons.warning_rounded
                    : Icons.error_rounded,
            size: 48,
            color: _getStatusColor(),
          ),
          const SizedBox(height: 12),
          Text(
            _getServerStatus(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Abonelik: ${_getRemainingDays()}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildModernInfoTile(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
    bool isUrl = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]?.withOpacity(0.3)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isUrl && value.length > 30 
                      ? '${value.substring(0, 30)}...'
                      : value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernActionButtons() {
    return Column(
      children: [
        // Refresh Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _isRefreshing ? null : _refreshContent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isRefreshing)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    else
                      const Icon(Icons.refresh_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      _isRefreshing ? 'Yenileniyor...' : 'İçerikleri Yenile',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Playlist List Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                try {
                  await UserPreferences.removeLastPlaylist();
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }
                } catch (e) {
                  print('Playlist listesine dönme hatası: $e');
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.list_rounded,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Playlist Listesi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}