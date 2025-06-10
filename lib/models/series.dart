class Series {
  final String seriesId;
  final String name;
  final String cover;
  final String plot;
  final String cast;
  final String director;
  final String genre;
  final String releasedate;
  final String rating;
  final String categoryId;

  Series({
    required this.seriesId,
    required this.name,
    required this.cover,
    required this.plot,
    required this.cast,
    required this.director,
    required this.genre,
    required this.releasedate,
    required this.rating,
    required this.categoryId,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      seriesId: json['series_id']?.toString() ?? '',
      name: json['name'] ?? '',
      cover: json['cover'] ?? '',
      plot: json['plot'] ?? '',
      cast: json['cast'] ?? '',
      director: json['director'] ?? '',
      genre: json['genre'] ?? '',
      releasedate: json['releasedate'] ?? '',
      rating: json['rating']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
    );
  }
}
