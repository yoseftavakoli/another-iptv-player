class Playlist {
  final String id;
  final String name;
  final PlaylistType type;
  final String? url;
  final String? username;
  final String? password;
  final DateTime createdAt;

  Playlist({
    required this.id,
    required this.name,
    required this.type,
    this.url,
    this.username,
    this.password,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'url': url,
      'username': username,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      type: PlaylistType.values.firstWhere((e) => e.toString() == json['type']),
      url: json['url'],
      username: json['username'],
      password: json['password'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

enum PlaylistType { xstream, m3u }
