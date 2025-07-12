import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/watch_history_controller.dart';
import '../models/watch_history.dart';
import '../widgets/watch_history/watch_history_empty_state.dart';
import '../widgets/watch_history/watch_history_content.dart';
import '../widgets/watch_history/watch_history_dialogs.dart';
import '../widgets/watch_history/watch_history_list_screen.dart';

class WatchHistoryScreen extends StatefulWidget {
  final String playlistId;

  const WatchHistoryScreen({super.key, required this.playlistId});

  @override
  State<WatchHistoryScreen> createState() => _WatchHistoryScreenState();
}

class _WatchHistoryScreenState extends State<WatchHistoryScreen> {
  late WatchHistoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WatchHistoryController();
    _controller.loadWatchHistory();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        body: Consumer<WatchHistoryController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(controller.errorMessage!)),
                );
              });
            }

            return RefreshIndicator(
              onRefresh: controller.loadWatchHistory,
              child: controller.isAllEmpty
                  ? const WatchHistoryEmptyState()
                  : WatchHistoryContent(
                      onHistoryTap: (history) =>
                          controller.playContent(context, history),
                      onHistoryRemove: (history) => _showRemoveDialog(history),
                      onSeeAllTap: _showAllHistory,
                    ),
            );
          },
        ),
      ),
    );
  }

  void _showAllHistory(String title, List<WatchHistory> histories) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WatchHistoryListScreen(
          title: title,
          histories: histories,
          onHistoryTap: (history) => _controller.playContent(context, history),
          onHistoryRemove: (history) => _showRemoveDialog(history),
        ),
      ),
    );
  }

  void _showRemoveDialog(history) {
    WatchHistoryDialogs.showRemoveDialog(
      context,
      onConfirm: () => _controller.removeHistory(history),
    );
  }
}