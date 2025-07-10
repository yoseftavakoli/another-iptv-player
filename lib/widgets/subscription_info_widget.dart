import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/api_response.dart';
import 'info_tile_widget.dart';
import 'section_title_widget.dart';

class SubscriptionInfoWidget extends StatelessWidget {
  final ApiResponse? serverInfo;

  const SubscriptionInfoWidget({super.key, required this.serverInfo});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(title: 'Abonelik Detayları'),
        Card(
          child: Column(
            children: [
              InfoTileWidget(
                icon: Icons.schedule,
                label: 'Kalan Süre',
                value: _getRemainingDays(),
                valueColor: _getStatusColor(),
              ),
              if (serverInfo?.userInfo != null)
                InfoTileWidget(
                  icon: Icons.devices,
                  label: 'Aktif Bağlantı',
                  value: serverInfo!.userInfo.activeCons.toString(),
                ),
              if (serverInfo?.userInfo != null)
                InfoTileWidget(
                  icon: Icons.device_hub,
                  label: 'Maksimum Bağlantı',
                  value: serverInfo!.userInfo.maxConnections.toString(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
