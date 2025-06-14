import 'package:flutter/material.dart';
import 'package:iptv_player/models/category_view_model.dart';
import 'package:iptv_player/utils/responsive_helper.dart';
import 'package:iptv_player/views/screens/home/content_detail_screen.dart';
import 'package:iptv_player/views/widgets/content_card.dart';

class CategoryDetailScreen extends StatelessWidget {
  final CategoryViewModel category;

  CategoryDetailScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: SelectableText(category.category.categoryName)),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.getCrossAxisCount(context),
          childAspectRatio: 0.65,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: category.contentItems.length,
        itemBuilder: (context, index) {
          return ContentCard(
            content: category.contentItems[index],
            width: 150,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentDetailScreen(
                    content: category.contentItems[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
