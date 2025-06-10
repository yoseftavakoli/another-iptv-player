class ServerInfo {
  final int? id;
  final String playlistId;
  final String url;
  final String port;
  final String httpsPort;
  final String serverProtocol;
  final String rtmpPort;
  final String timezone;
  final int timestampNow;
  final String timeNow;

  ServerInfo({
    this.id,
    required this.playlistId,
    required this.url,
    required this.port,
    required this.httpsPort,
    required this.serverProtocol,
    required this.rtmpPort,
    required this.timezone,
    required this.timestampNow,
    required this.timeNow,
  });

  factory ServerInfo.fromJson(Map<String, dynamic> json, String playlistId) {
    return ServerInfo(
      playlistId: playlistId,
      url: json['url'] ?? '',
      port: json['port'] ?? '',
      httpsPort: json['https_port'] ?? '',
      serverProtocol: json['server_protocol'] ?? '',
      rtmpPort: json['rtmp_port'] ?? '',
      timezone: json['timezone'] ?? '',
      timestampNow: json['timestamp_now'] ?? 0,
      timeNow: json['time_now'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playlistId': playlistId,
      'url': url,
      'port': port,
      'httpsPort': httpsPort,
      'serverProtocol': serverProtocol,
      'rtmpPort': rtmpPort,
      'timezone': timezone,
      'timestampNow': timestampNow,
      'timeNow': timeNow,
    };
  }
}
