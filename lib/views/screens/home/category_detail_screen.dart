import 'package:flutter/material.dart';
import 'package:iptv_player/models/category_view_model.dart';
import 'package:iptv_player/utils/navigate_by_content_type.dart';
import 'package:iptv_player/utils/responsive_helper.dart';
import 'package:iptv_player/views/widgets/content_card.dart';

class CategoryDetailScreen extends StatelessWidget {
  final CategoryViewModel category;

  const CategoryDetailScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildContentGrid(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: SelectableText(category.category.categoryName),
    );
  }

  Widget _buildContentGrid(BuildContext context) {
    if (category.contentItems.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: _buildGridDelegate(context),
      itemCount: category.contentItems.length,
      itemBuilder: (context, index) => _buildContentItem(context, index),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Bu kategoride içerik bulunamadı',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _buildGridDelegate(BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: ResponsiveHelper.getCrossAxisCount(context),
      childAspectRatio: 0.65,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    );
  }

  Widget _buildContentItem(BuildContext context, int index) {
    final contentItem = category.contentItems[index];
    
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