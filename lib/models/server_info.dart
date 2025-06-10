// models/server_info.dart
import 'package:iptv_player/models/user_info.dart';

class ServerInfo {
  final String url;
  final String port;
  final String httpsPort;
  final String serverProtocol;
  final String rtmpPort;
  final String timezone;
  final int timestampNow;
  final String timeNow;

  ServerInfo({
    required this.url,
    required this.port,
    required this.httpsPort,
    required this.serverProtocol,
    required this.rtmpPort,
    required this.timezone,
    required this.timestampNow,
    required this.timeNow,
  });

  factory ServerInfo.fromJson(Map<String, dynamic> json) {
    return ServerInfo(
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
}

// models/api_response.dart
class ApiResponse {
  final UserInfo userInfo;
  final ServerInfo serverInfo;

  ApiResponse({required this.userInfo, required this.serverInfo});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      userInfo: UserInfo.fromJson(json['user_info'] ?? {}),
      serverInfo: ServerInfo.fromJson(json['server_info'] ?? {}),
    );
  }
}