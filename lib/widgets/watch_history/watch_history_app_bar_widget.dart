import 'package:flutter/material.dart';

class WatchHistoryAppBar extends StatelessWidget {
  final VoidCallback? onRefresh;
  final VoidCallback? onClearAll;

  const WatchHistoryAppBar({super.key, this.onRefresh, this.onClearAll});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: const Text('İzleme Geçmişi'),
      floating: true,
      snap: true,
      elevation: 0,
      actions: [
        PopupMenuButton<String>(
          onSelected: (action) => _handleMenuAction(action, context),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 8),
                  Text('Yenile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'clear_all',
              child: Row(
                children: [
                  Icon(Icons.clear_all, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Tümünü Temizle', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleMenuAction(String action, BuildContext context) {
    switch (action) {
      case 'refresh':
        onRefresh?.call();
        break;
      case 'clear_all':
        _onClearAllTap(context);
        break;
    }
  }

  void _onClearAllTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tümünü Temizle'),
        content: const Text(
          'Tüm izleme geçmişini silmek istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onClearAll?.call();
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
