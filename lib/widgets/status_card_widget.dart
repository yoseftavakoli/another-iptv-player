import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/api_response.dart';
import 'package:another_iptv_player/l10n/localization_extension.dart';

class StatusCardWidget extends StatelessWidget {
  final ApiResponse? serverInfo;

  const StatusCardWidget({super.key, required this.serverInfo});

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

  String _getServerStatus(BuildContext context) {
    return serverInfo != null
        ? context.loc.connected
        : context.loc.no_connection;
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
    return Card(
      child: ListTile(
        leading: Icon(
          _getStatusColor(context) == Colors.green
              ? Icons.check_circle
              : _getStatusColor(context) == Colors.orange
              ? Icons.warning
              : Icons.error,
          color: _getStatusColor(context),
          size: 36,
        ),
        title: Text(
          _getServerStatus(context),
          style: TextStyle(color: _getStatusColor(context)),
        ),
        subtitle: Text(
          context.loc.subscription_remaining_day(_getRemainingDays(context)),
        ),
      ),
    );
  }
}
