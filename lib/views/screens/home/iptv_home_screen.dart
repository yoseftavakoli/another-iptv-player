import 'package:flutter/material.dart';
import 'package:iptv_player/controllers/home_controller.dart';
import 'package:iptv_player/database/database.dart';
import 'package:iptv_player/models/api_configuration_model.dart';
import 'package:iptv_player/models/category_view_model.dart';
import 'package:iptv_player/models/playlist_model.dart';
import 'package:iptv_player/repositories/iptv_repository.dart';
import 'package:iptv_player/utils/responsive_helper.dart';
import 'package:iptv_player/views/screens/home/category_detail_screen.dart';
import 'package:iptv_player/views/screens/home/content_detail_screen.dart';
import 'package:iptv_player/views/widgets/category_section.dart';
import 'package:provider/provider.dart';

class IPTVHomeScreen extends StatefulWidget {
  final Playlist playlist;

  const IPTVHomeScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  _IPTVHomeScreenState createState() => _IPTVHomeScreenState();
}

class _IPTVHomeScreenState extends State<IPTVHomeScreen> {
  late HomeController _controller;

  @override
  void initState() {
    super.initState();

    final repository = IptvRepository(
      ApiConfig(
        baseUrl: widget.playlist.url!,
        username: widget.playlist.username!,
        password: widget.playlist.password!,
      ),
      AppDatabase(),
      widget.playlist.id,
    );
    _controller = HomeController(repository: repository);
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
      child: Consumer<HomeController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Playlistler yükleniyor...'),
                ],
              ),
            );
          }

          return Scaffold(
            body: PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: [
                _buildContentPage(controller.liveCategories!, 'live'),
                _buildContentPage(controller.movieCategories!, 'movie'),
                _buildContentPage(controller.seriesCategories!, 'series'),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: controller.currentIndex,
              onTap: controller.onNavigationTap,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.live_tv),
                  label: 'Canlı',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Film'),
                BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Dizi'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentPage(List<CategoryViewModel> categories, String type) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Text(
              _controller.getPageTitle(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            floating: true,
            snap: true,
            elevation: 0,
          ),
        ];
      },
      body: _buildCategoryList(categories, type),
    );
  }

  Widget _buildCategoryList(List<CategoryViewModel> categories, String type) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategorySection(
          category: categories[index],
          type: type,
          cardWidth: ResponsiveHelper.getCardWidth(context),
          cardHeight: ResponsiveHelper.getCardHeight(context),
          onSeeAllTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetailScreen(
                  category: categories[index],
                ),
              ),
            );
          },
          onContentTap: (content) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContentDetailScreen(content: content),
              ),
            );
          },
        );
      },
    );
  }
}
