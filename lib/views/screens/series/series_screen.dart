import 'package:flutter/material.dart';
import 'package:iptv_player/models/playlist_content_model.dart';
import 'package:iptv_player/services/app_state.dart';

class SeriesScreen extends StatelessWidget {
  final ContentItem contentItem;

  const SeriesScreen({super.key, required this.contentItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 400.0,
              floating: false,
              pinned: false,
              snap: false,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Hero sadece görsel için
                    Hero(
                      tag: contentItem.id,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: _buildCoverImage(),
                      ),
                    ),
                    // Gradient overlay - Hero dışında
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.7, 1.0],
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                    // Text'ler Hero dışında ve Material ile sarılmış
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contentItem.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    color: Colors.black54,
                                  ),
                                ],
                                decoration: TextDecoration.none,
                              ),
                            ),
                            if (contentItem.seriesStream?.genre != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                contentItem.seriesStream!.genre!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black54,
                                    ),
                                  ],
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating Bölümü
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          index <
                                  (contentItem.seriesStream?.rating5based
                                          ?.round() ??
                                      0)
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 24,
                        ),
                      );
                    }),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${contentItem.seriesStream?.rating5based?.toStringAsFixed(1) ?? '0.0'}/5',
                        style: TextStyle(
                          color: Colors.amber.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Sezonlar Bölümü
                Text(
                  'Sezonlar',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Sezonlar Listesi
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3, // Geçici olarak 3 sezon
                    itemBuilder: (context, index) {
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Sezon detay sayfasına geçiş
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.play_circle_outline,
                                          size: 20,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Sezon ${index + 1}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${(index + 1) * 8} Bölüm', // Geçici
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Dizi Bilgileri
                if (contentItem.seriesStream?.plot != null) ...[
                  _buildDetailCard(
                    icon: Icons.description,
                    title: 'Açıklama',
                    value: contentItem.seriesStream!.plot!,
                  ),
                  const SizedBox(height: 12),
                ],

                _buildDetailCard(
                  icon: Icons.calendar_today,
                  title: 'Çıkış Tarihi',
                  value: contentItem.seriesStream?.releaseDate ?? 'Bilinmiyor',
                ),
                const SizedBox(height: 12),

                if (contentItem.seriesStream?.genre != null) ...[
                  _buildDetailCard(
                    icon: Icons.movie,
                    title: 'Tür',
                    value: contentItem.seriesStream!.genre!,
                  ),
                  const SizedBox(height: 12),
                ],

                if (contentItem.seriesStream?.cast != null) ...[
                  _buildDetailCard(
                    icon: Icons.people,
                    title: 'Oyuncular',
                    value: contentItem.seriesStream!.cast!,
                  ),
                  const SizedBox(height: 12),
                ],

                if (contentItem.seriesStream?.episodeRunTime != null) ...[
                  _buildDetailCard(
                    icon: Icons.access_time,
                    title: 'Bölüm Süresi',
                    value: '${contentItem.seriesStream!.episodeRunTime} dakika',
                  ),
                  const SizedBox(height: 12),
                ],

                _buildDetailCard(
                  icon: Icons.category,
                  title: 'Kategori ID',
                  value: contentItem.seriesStream?.categoryId ?? 'Belirtilmemiş',
                ),
                const SizedBox(height: 12),

                _buildDetailCard(
                  icon: Icons.tag,
                  title: 'Dizi ID',
                  value: contentItem.seriesStream?.seriesId?.toString() ??
                      contentItem.id.toString(),
                ),
                
                // En alta padding ekle
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    final hasBackdrop = contentItem.seriesStream?.backdropPath?.isNotEmpty == true;
    final hasCover = contentItem.seriesStream?.cover?.isNotEmpty == true;
    
    if (hasBackdrop || hasCover) {
      final imageUrl = hasBackdrop 
          ? contentItem.seriesStream!.backdropPath![0]
          : contentItem.seriesStream!.cover!;
      
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          
          return Container(
            color: Colors.grey.withOpacity(0.2),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Görsel yükleniyor...',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }
    
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.tv,
                size: 64,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Görsel Bulunamadı',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              contentItem.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}