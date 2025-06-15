import 'package:flutter/material.dart';
import 'package:iptv_player/models/category.dart';
import 'package:iptv_player/models/category_view_model.dart';
import 'package:iptv_player/models/playlist_content_model.dart';
import 'package:iptv_player/services/app_state.dart';
import 'package:iptv_player/utils/navigate_by_content_type.dart';
import 'package:iptv_player/utils/responsive_helper.dart';
import 'package:iptv_player/views/widgets/content_card.dart';

class CategoryDetailScreen extends StatefulWidget {
  final CategoryViewModel category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  List<ContentItem> contentItems = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadContentItems();
  }

  Future<void> _loadContentItems() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      var repository = AppState.repository!;
      List<ContentItem> items = [];

      switch (widget.category.category.type) {
        case CategoryType.live:
          items =
              (await repository.getLiveChannelsByCategoryId(
                    categoryId: widget.category.category.categoryId,
                  ))!
                  .map(
                    (x) => ContentItem(
                      x.streamId,
                      x.name,
                      x.streamIcon,
                      ContentType.liveStream,
                      liveStream: x,
                    ),
                  )
                  .toList();
        case CategoryType.vod:
          items =
              (await repository.getMovies(
                    categoryId: widget.category.category.categoryId,
                  ))!
                  .map(
                    (x) => ContentItem(
                      x.streamId,
                      x.name,
                      x.streamIcon,
                      ContentType.vod,
                      containerExtension: x.containerExtension,
                      vodStream: x,
                    ),
                  )
                  .toList();
        case CategoryType.series:
          items =
              (await repository.getSeries(
                    categoryId: widget.category.category.categoryId,
                  ))!
                  .map(
                    (x) => ContentItem(
                      x.seriesId,
                      x.name,
                      x.cover,
                      ContentType.series,
                      seriesStream: x,
                    ),
                  )
                  .toList();
      }

      setState(() {
        contentItems = items;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody(context));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: SelectableText(widget.category.category.categoryName));
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return _buildErrorState();
    }

    return _buildContentGrid(context);
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Hata: $errorMessage',
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadContentItems,
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildContentGrid(BuildContext context) {
    if (contentItems.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: _buildGridDelegate(context),
      itemCount: contentItems.length,
      itemBuilder: (context, index) => _buildContentItem(context, index),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Bu kategoride içerik bulunamadı',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _buildGridDelegate(
    BuildContext context,
  ) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: ResponsiveHelper.getCrossAxisCount(context),
      childAspectRatio: 0.65,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    );
  }

  Widget _buildContentItem(BuildContext context, int index) {
    final contentItem = contentItems[index];

    return ContentCard(
      content: contentItem,
      width: 150,
      onTap: () => _handleContentTap(context, contentItem),
    );
  }

  void _handleContentTap(BuildContext context, dynamic contentItem) {
    navigateByContentType(context, contentItem);
  }
}
