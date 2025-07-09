import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/playlist_content_model.dart';


class ContentCard extends StatelessWidget {
  final ContentItem content;
  final double width;
  final VoidCallback? onTap;
  final bool isSelected;

  const ContentCard({
    super.key,
    required this.content,
    required this.width,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardWidget = Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null, // null = default card color
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: content.imagePath.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: content.imagePath,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          _buildTitleCard(context),
                    )
                  : _buildTitleCard(context),
            ),
          ],
        ),
      ),
    );

    return Hero(tag: content.id, child: cardWidget);
  }

  Widget _buildTitleCard(BuildContext context) {
    return Container(
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Text(
            content.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : null,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
