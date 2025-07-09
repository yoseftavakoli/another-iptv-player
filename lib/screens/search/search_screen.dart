
import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/content_type.dart';
import 'package:another_iptv_player/models/playlist_content_model.dart';
import 'package:another_iptv_player/repositories/iptv_repository.dart';
import 'package:another_iptv_player/services/app_state.dart';
import 'package:another_iptv_player/utils/navigate_by_content_type.dart';
import 'package:another_iptv_player/utils/responsive_helper.dart';

import '../../../widgets/content_card.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({super.key});

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool isSearching = false;
  bool isLoading = false;
  String? errorMessage;
  bool isSearched = false;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  List<ContentItem> contentItems = [];
  IptvRepository repository = AppState.repository!;

  @override
  void initState() {
    super.initState();
    // Ekran açıldığında otomatik olarak arama modunu başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startSearch();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void startSearch() {
    setState(() {
      isSearching = true;
      isSearched = true;
    });
    // Focus'u arama alanına yönlendir
    Future.delayed(Duration(milliseconds: 100), () {
      searchFocusNode.requestFocus();
    });
  }

  void stopSearch() {
    setState(() {
      isSearching = false;
      searchController.clear();
    });
    searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          controller: searchController,
          focusNode: searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Ara...',
            border: InputBorder.none,
          ),
          autofocus: true,
          onChanged: (value) async {
            if (value.isEmpty || value.trim().isEmpty) {
              setState(() {
                contentItems = [];
              });
            } else {
              setState(() {
                isLoading = true;
                errorMessage = null;
                contentItems = [];
              });

              var liveStreams = await repository.searchLiveStreams(value);
              var vodStreams = await repository.searchMovies(value);
              var series = await repository.searchSeries(value);

              setState(() {
                contentItems = [
                  ...contentItems,
                  ...liveStreams.map(
                        (x) => ContentItem(
                      x.streamId,
                      x.name,
                      x.streamIcon,
                      ContentType.liveStream,
                    ),
                  ),
                  ...vodStreams.map(
                        (x) => ContentItem(
                      x.streamId,
                      x.name,
                      x.streamIcon,
                      ContentType.vod,
                      containerExtension: x.containerExtension,
                      vodStream: x,
                    ),
                  ),
                  ...series.map(
                        (x) => ContentItem(
                      x.seriesId,
                      x.name,
                      x.cover,
                      ContentType.series,
                      seriesStream: x,
                    ),
                  ),
                ];

                isLoading = false;
              });
            }
          },
        )
            : Text('Arama'),
        actions: [
          if (isSearching)
            IconButton(icon: Icon(Icons.clear), onPressed: stopSearch)
          else
            IconButton(icon: Icon(Icons.search), onPressed: startSearch),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return _buildErrorState();
    }

    return _buildContentGrid(context);
  }

  Widget _buildContentGrid(BuildContext context) {
    if (contentItems.isEmpty && isSearched) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: _buildGridDelegate(context),
      itemCount: contentItems.length,
      itemBuilder: (context, index) =>
          _buildContentItem(context, index, contentItems),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _buildGridDelegate(
      BuildContext context,
      ) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: ResponsiveHelper.getCrossAxisCount(context),
      childAspectRatio: 0.65,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    );
  }

  Widget _buildContentItem(
      BuildContext context,
      int index,
      List<ContentItem> contentItems,
      ) {
    final contentItem = contentItems[index];

    return ContentCard(
      content: contentItem,
      width: 150,
      onTap: () => navigateByContentType(context, contentItem),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'İçerik bulunamadı',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Hata: $errorMessage',
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}