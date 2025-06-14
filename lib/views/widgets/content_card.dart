import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iptv_player/models/playlist_content_model.dart';

class ContentCard extends StatelessWidget {
  final ContentItem content;
  final double width;
  final VoidCallback? onTap;

  const ContentCard({
    Key? key,
    required this.content,
    required this.width,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: content.id,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 3,
                child: content.imagePath != null
                    ? CachedNetworkImage(
                        imageUrl: content.imagePath,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
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
              Container(
                height: 45,
                padding: EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        content.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleCard(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Text(
            content.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
