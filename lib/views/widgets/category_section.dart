import 'package:flutter/material.dart';
import 'package:iptv_player/models/category_view_model.dart';
import 'package:iptv_player/views/widgets/content_card.dart';
import 'package:iptv_player/models/playlist_content_model.dart';

class CategorySection extends StatelessWidget {
  final CategoryViewModel category;
  final String type;
  final double cardWidth;
  final double cardHeight;
  final VoidCallback? onSeeAllTap;
  final Function(ContentItem)? onContentTap;

  const CategorySection({
    Key? key,
    required this.category,
    required this.type,
    required this.cardWidth,
    required this.cardHeight,
    this.onSeeAllTap,
    this.onContentTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SelectableText(
                    category.category.categoryName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onSeeAllTap,
                  child: Text('Tümünü Gör', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: cardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: category.contentItems.length,
              itemBuilder: (context, index) {
                return Container(
                  width: cardWidth,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: ContentCard(
                    content: category.contentItems[index],
                    width: cardWidth,
                    onTap: () =>
                        onContentTap?.call(category.contentItems[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
