class UserInfo {
  final int? id;
  final String playlistId;
  final String username;
  final String password;
  final String message;
  final int auth;
  final String status;
  final String expDate;
  final String isTrial;
  final String activeCons;
  final String createdAt;
  final String maxConnections;
  final List<String> allowedOutputFormats;

  UserInfo({
    this.id,
    required this.playlistId,
    required this.username,
    required this.password,
    required this.message,
    required this.auth,
    required this.status,
    required this.expDate,
    required this.isTrial,
    required this.activeCons,
    required this.createdAt,
    required this.maxConnections,
    required this.allowedOutputFormats,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json, String playlistId) {
    return UserInfo(
      playlistId: playlistId,
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      message: json['message'] ?? '',
      auth: json['auth'] ?? 0,
      status: json['status'] ?? '',
      expDate: json['exp_date'] ?? '',
      isTrial: json['is_trial'] ?? '',
      activeCons: json['active_cons'] ?? '',
      createdAt: json['created_at'] ?? '',
      maxConnections: json['max_connections'] ?? '',
      allowedOutputFormats: json['allowed_output_formats'] != null
          ? List<String>.from(json['allowed_output_formats'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playlistId': playlistId,
      'username': username,
      'password': password,
      'message': message,
      'auth': auth,
      'status': status,
      'expDate': expDate,
      'isTrial': isTrial,
      'activeCons': activeCons,
      'createdAt': createdAt,
      'maxConnections': maxConnections,
      'allowedOutputFormats': allowedOutputFormats,
    };
  }
}
