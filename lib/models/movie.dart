class Movie {
  final String streamId;
  final String name;
  final String streamIcon;
  final String categoryId;
  final String containerExtension;
  final String plot;
  final String cast;
  final String director;
  final String genre;
  final String releasedate;
  final String rating;

  Movie({
    required this.streamId,
    required this.name,
    required this.streamIcon,
    required this.categoryId,
    required this.containerExtension,
    required this.plot,
    required this.cast,
    required this.director,
    required this.genre,
    required this.releasedate,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      streamId: json['stream_id']?.toString() ?? '',
      name: json['name'] ?? '',
      streamIcon: json['stream_icon'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      containerExtension: json['container_extension'] ?? '',
      plot: json['plot'] ?? '',
      cast: json['cast'] ?? '',
      director: json['director'] ?? '',
      genre: json['genre'] ?? '',
      releasedate: json['releasedate'] ?? '',
      rating: json['rating']?.toString() ?? '',
    );
  }
}
