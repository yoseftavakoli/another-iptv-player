import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/api_response.dart';
import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'info_tile_widget.dart';
import 'section_title_widget.dart';

class SubscriptionInfoWidget extends StatelessWidget {
  final ApiResponse? serverInfo;

  const SubscriptionInfoWidget({super.key, required this.serverInfo});

  String _getRemainingDays(BuildContext context) {
    if (serverInfo?.userInfo.expDate != null) {
      final expDate = serverInfo!.userInfo.expDate;
      try {
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(expDate.toString()) * 1000,
        );
        final now = DateTime.now();
        final difference = expiryDate.difference(now).inDays;
        return difference > 0
            ? context.loc.remaining_day(difference.toString())
            : context.loc.expired;
      } catch (e) {
        return context.loc.not_found_in_category;
      }
    }
    return context.loc.not_found_in_category;
  }

  Color _getStatusColor(BuildContext context) {
    if (serverInfo != null) {
      final remaining = _getRemainingDays(context);
      if (remaining == context.loc.expired) return Colors.red;
      if (remaining.contains(context.loc.day)) {
        final RegExp numberRegex = RegExp(r'\d+');
        final match = numberRegex.firstMatch(remaining);
        if (match != null) {
          final days = int.tryParse(match.group(0)!) ?? 0;
          if (days <= 7) return Colors.orange;
          return Colors.green;
        }
      }
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(title: context.loc.subscription_details),
        Card(
          child: Column(
            children: [
              InfoTileWidget(
                icon: Icons.schedule,
                label: context.loc.remaining_day_title,
                value: _getRemainingDays(context),
                valueColor: _getStatusColor(context),
              ),
              if (serverInfo?.userInfo != null)
                InfoTileWidget(
                  icon: Icons.devices,
                  label: context.loc.active_connection,
                  value: serverInfo!.userInfo.activeCons.toString(),
                ),
              if (serverInfo?.userInfo != null)
                InfoTileWidget(
                  icon: Icons.device_hub,
                  label: context.loc.maximum_connection,
                  value: serverInfo!.userInfo.maxConnections.toString(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
