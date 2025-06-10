import 'package:flutter/material.dart';
import 'package:iptv_player/controllers/playlist_content_controller.dart';
import 'package:iptv_player/database/database.dart';
import 'package:iptv_player/models/api_configuration_model.dart';
import 'package:iptv_player/models/category.dart';
import 'package:iptv_player/models/playlist_content_model.dart';
import 'package:iptv_player/models/playlist_model.dart';
import 'package:iptv_player/repositories/iptv_repository.dart';
import 'package:provider/provider.dart';

class PlaylistContentScreen extends StatefulWidget {
  final Playlist playlist;
  const PlaylistContentScreen({Key? key, required this.playlist})
    : super(key: key);

  @override
  State<PlaylistContentScreen> createState() => _PlaylistContentScreenState();
}

class _PlaylistContentScreenState extends State<PlaylistContentScreen> {
  late PlaylistContentController _controller;

  @override
  void initState() {
    super.initState();
    // Repository'yi oluştur
    final repository = IptvRepository(
      ApiConfig(
        baseUrl: widget.playlist.url!,
        username: widget.playlist.username!,
        password: widget.playlist.password!,
      ),
      AppDatabase(),
      widget.playlist.id,
    );

    // Controller'ı playlist ile birlikte oluştur
    _controller = PlaylistContentController(repository: repository);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<PlaylistContentController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: _buildAppBar(context, controller),
            body: _buildBody(context, controller),
            bottomNavigationBar: _buildBottomNavigation(context, controller),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PlaylistContentController controller,
  ) {
    return AppBar(
      title: Text(
        widget.playlist.name,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      backgroundColor: controller.getColorForCurrentTab(),
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildBody(
    BuildContext context,
    PlaylistContentController controller,
  ) {
    if (controller.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: controller.getColorForCurrentTab(),
            ),
            SizedBox(height: 16),
            Text(
              'İçerik yükleniyor...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 768;
        return isDesktop
            ? _buildDesktopLayout(context, controller)
            : _buildMobileLayout(context, controller);
      },
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    PlaylistContentController controller,
  ) {
    if (controller.selectedCategory == null) {
      return _buildCategoriesList(context, controller);
    } else {
      return _buildContentList(context, controller);
    }
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    PlaylistContentController controller,
  ) {
    return Row(
      children: [
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(right: BorderSide(color: Colors.grey[300]!)),
          ),
          child: _buildCategoriesList(context, controller),
        ),
        Expanded(
          child: controller.selectedCategory == null
              ? _buildSelectCategoryMessage(context, controller)
              : _buildContentList(context, controller),
        ),
      ],
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    PlaylistContentController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            children: [
              Icon(
                controller.getIconForCurrentTab(),
                color: controller.getColorForCurrentTab(),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Kategoriler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: controller.currentCategories!.length,
            itemBuilder: (context, index) {
              Category category = controller.currentCategories![index];
              bool isSelected = controller.selectedCategory == category;
              int itemCount = 0;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? controller.getColorForCurrentTab().withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(
                          color: controller.getColorForCurrentTab().withOpacity(
                            0.3,
                          ),
                        )
                      : null,
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  title: Text(
                    category.categoryName,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? controller.getColorForCurrentTab()
                          : Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '$itemCount içerik',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: isSelected
                        ? controller.getColorForCurrentTab()
                        : Colors.grey[400],
                  ),
                  onTap: () => controller.selectCategory(category!),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContentList(
    BuildContext context,
    PlaylistContentController controller,
  ) {
    return Column(
      children: [
        _buildContentHeader(context, controller),
        Expanded(
          child: controller.currentContent.isEmpty
              ? _buildEmptyState(context, controller)
              : _buildContentGrid(context, controller),
        ),
      ],
    );
  }

  Widget _buildContentHeader(
    BuildContext context,
    PlaylistContentController controller,
  ) {
    bool isMobile = MediaQuery.of(context).size.width <= 768;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          if (isMobile) ...[
            IconButton(
              onPressed: () => controller.clearCategorySelection(),
              icon: Icon(Icons.arrow_back),
              style: IconButton.styleFrom(
                backgroundColor: controller.getColorForCurrentTab().withOpacity(
                  0.1,
                ),
                foregroundColor: controller.getColorForCurrentTab(),
              ),
            ),
            SizedBox(width: 12),
          ],
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: controller.getColorForCurrentTab().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              controller.getIconForCurrentTab(),
              color: controller.getColorForCurrentTab(),
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.selectedCategory?.categoryName ?? '',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '${controller.currentContent.length} içerik • ${controller.getTabName()}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentGrid(
    BuildContext context,
    PlaylistContentController controller,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: controller.currentContent.length,
      itemBuilder: (context, index) {
        return _buildContentItem(
          context,
          controller,
          controller.currentContent[index],
        );
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1400) return 6;
    if (width > 1100) return 5;
    if (width > 800) return 4;
    if (width > 600) return 3;
    return 2;
  }

  Widget _buildContentItem(
    BuildContext context,
    PlaylistContentController controller,
    ContentItem item,
  ) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          controller.onContentTap(item);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    controller.getIconForCurrentTab(),
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(child: Text('${item.name} seçildi')),
                ],
              ),
              backgroundColor: controller.getColorForCurrentTab(),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.network(
                        item.imagePath,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            controller.getIconForCurrentTab(),
                            size: 48,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                    if (item.duration != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${item.duration!.inHours}:${(item.duration!.inMinutes % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.description != null) ...[
                      SizedBox(height: 4),
                      Text(
                        item.description!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectCategoryMessage(
    BuildContext context,
    PlaylistContentController controller,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: controller.getColorForCurrentTab().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.playlist_play,
                size: 64,
                color: controller.getColorForCurrentTab(),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Bir kategori seçin',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Sol menüden görüntülemek istediğiniz\nkategoriyi seçerek içerikleri keşfedin',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    PlaylistContentController controller,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 32),
            Text(
              'İçerik bulunamadı',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Bu kategoride henüz içerik bulunmuyor.\nYakında yeni içerikler eklenecek.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(
    BuildContext context,
    PlaylistContentController controller,
  ) {
    return NavigationBar(
      selectedIndex: controller.selectedNavIndex,
      onDestinationSelected: controller.selectNavigationTab,
      backgroundColor: Colors.white,
      surfaceTintColor: controller.getColorForCurrentTab(),
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.live_tv_outlined),
          selectedIcon: Icon(Icons.live_tv),
          label: 'Canlı Yayın',
        ),
        NavigationDestination(
          icon: Icon(Icons.movie_outlined),
          selectedIcon: Icon(Icons.movie),
          label: 'Filmler',
        ),
        NavigationDestination(
          icon: Icon(Icons.tv_outlined),
          selectedIcon: Icon(Icons.tv),
          label: 'Diziler',
        ),
      ],
    );
  }
}
