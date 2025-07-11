import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/api_response.dart';

class StatusCardWidget extends StatelessWidget {
  final ApiResponse? serverInfo;

  const StatusCardWidget({super.key, required this.serverInfo});

  String _getRemainingDays() {
    if (serverInfo?.userInfo.expDate != null) {
      final expDate = serverInfo!.userInfo.expDate;
      try {
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(expDate.toString()) * 1000,
        );
        final now = DateTime.now();
        final difference = expiryDate.difference(now).inDays;
        return difference > 0 ? '$difference gün' : 'Süresi dolmuş';
      } catch (e) {
        return 'Bilinmiyor';
      }
    }
    return 'Bilinmiyor';
  }

  String _getServerStatus() {
    return serverInfo != null ? 'Bağlı' : 'Bağlantı yok';
  }

  Color _getStatusColor() {
    if (serverInfo != null) {
      final remaining = _getRemainingDays();
      if (remaining == 'Süresi dolmuş') return Colors.red;
      if (remaining.contains('gün')) {
        final days = int.tryParse(remaining.split(' ')[0]) ?? 0;
        if (days <= 7) return Colors.orange;
        return Colors.green;
      }
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          _getStatusColor() == Colors.green
              ? Icons.check_circle
              : _getStatusColor() == Colors.orange
              ? Icons.warning
              : Icons.error,
          color: _getStatusColor(),
          size: 36,
        ),
        title: Text(
          _getServerStatus(),
          style: TextStyle(
            color: _getStatusColor(),
          ),
        ),
        subtitle: Text('Abonelik: ${_getRemainingDays()}'),
      ),
    );
  }
}
