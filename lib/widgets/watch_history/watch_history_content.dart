import 'package:another_iptv_player/models/watch_history.dart';
import 'package:another_iptv_player/widgets/watch_history/watch_history_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:another_iptv_player/utils/responsive_helper.dart';
import '../../controllers/watch_history_controller.dart';
import 'watch_history_section.dart';

class WatchHistoryContent extends StatelessWidget {
  final Function(dynamic) onHistoryTap;
  final Function(dynamic) onHistoryRemove;
  final Function(String, List<WatchHistory>) onSeeAllTap;

  const WatchHistoryContent({
    super.key,
    required this.onHistoryTap,
    required this.onHistoryRemove,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchHistoryController>(
      builder: (context, controller, child) {
        final cardWidth = ResponsiveHelper.getCardWidth(context);
        final cardHeight = ResponsiveHelper.getCardHeight(context);

        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              WatchHistoryAppBar(
                onRefresh: controller.loadWatchHistory,
                onClearAll: controller.clearAllHistory,
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children: [
                WatchHistorySection(
                  title: 'Canlı Yayınlar',
                  histories: controller.liveHistory,
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  onHistoryTap: onHistoryTap,
                  onHistoryRemove: onHistoryRemove,
                  onSeeAllTap: () => onSeeAllTap('Canlı Yayınlar', controller.liveHistory),
                ),
                WatchHistorySection(
                  title: 'Filmler',
                  histories: controller.movieHistory,
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  showProgress: true,
                  onHistoryTap: onHistoryTap,
                  onHistoryRemove: onHistoryRemove,
                  onSeeAllTap: () => onSeeAllTap('Filmler', controller.movieHistory),
                ),
                WatchHistorySection(
                  title: 'Diziler',
                  histories: controller.seriesHistory,
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  showProgress: true,
                  onHistoryTap: onHistoryTap,
                  onHistoryRemove: onHistoryRemove,
                  onSeeAllTap: () => onSeeAllTap('Diziler', controller.seriesHistory),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}