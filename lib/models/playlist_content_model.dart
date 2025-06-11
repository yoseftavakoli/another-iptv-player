enum ContentType { liveStream, vod, series }

class ContentItem {
  final String id;
  final String name;
  final String imagePath;
  final String? description;
  final Duration? duration;
  final String? coverPath;
  final String? containerExtension;
  final ContentType contentType;

  ContentItem(
    this.id,
    this.name,
    this.imagePath,
    this.contentType, {
    this.description,
    this.duration,
    this.coverPath,
    this.containerExtension
  });
}

class PlaylistContentModel {}
