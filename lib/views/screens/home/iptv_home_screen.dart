import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iptv_player/controllers/home_controller.dart';
import 'package:iptv_player/database/database.dart';
import 'package:iptv_player/models/api_configuration_model.dart';
import 'package:iptv_player/models/category_view_model.dart';
import 'package:iptv_player/models/playlist_model.dart';
import 'package:iptv_player/repositories/iptv_repository.dart';
import 'package:iptv_player/services/app_state.dart';
import 'package:iptv_player/utils/navigate_by_content_type.dart';
import 'package:iptv_player/utils/responsive_helper.dart';
import 'package:iptv_player/views/screens/home/category_detail_screen.dart';
import 'package:iptv_player/views/screens/search/search_screen.dart';
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
  late PersistentTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = PersistentTabController(initialIndex: 0);

    final repository = IptvRepository(
      ApiConfig(
        baseUrl: widget.playlist.url!,
        username: widget.playlist.username!,
        password: widget.playlist.password!,
      ),
      AppDatabase(),
      widget.playlist.id,
    );

    AppState.repository = repository;
    _controller = HomeController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      _buildContentPage(_controller.liveCategories ?? [], 'live', _controller),
      _buildContentPage(
        _controller.movieCategories ?? [],
        'movie',
        _controller,
      ),
      _buildContentPage(
        _controller.seriesCategories ?? [],
        'series',
        _controller,
      ),
      SearchAppBar(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.live_tv),
        title: "Canlı",
        activeColorPrimary: Theme.of(context).colorScheme.onSurface,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.movie_outlined),
        title: "Film",
        activeColorPrimary: Theme.of(context).colorScheme.onSurface,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.tv),
        title: "Dizi",
        activeColorPrimary: Theme.of(context).colorScheme.onSurface,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: "Arama",
        activeColorPrimary: Theme.of(context).colorScheme.onSurface,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: ChangeNotifierProvider.value(
        value: _controller,
        child: Consumer<HomeController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Playlistler yükleniyor...'),
                    ],
                  ),
                ),
              );
            }

            return PersistentTabView(
              context,
              controller: _tabController,
              screens: _buildScreens(),
              items: _navBarsItems(),
              backgroundColor: Theme.of(context).primaryColor,
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset: true,
              stateManagement: true,
              hideNavigationBarWhenKeyboardAppears: true,
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(0),
                colorBehindNavBar: Colors.white,
              ),
              navBarStyle: NavBarStyle.style9, // Bu stili değiştirebilirsiniz
            );
          },
        ),
      ),
    );
  }

  Widget _buildContentPage(
    List<CategoryViewModel> categories,
    String type,
    HomeController controller,
  ) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: SelectableText(
              _getPageTitle(type),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            floating: true,
            snap: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  controller.refreshAllData(context);
                },
              ),
            ],
          ),
        ];
      },
      body: _buildCategoryList(categories, type),
    );
  }

  String _getPageTitle(String type) {
    switch (type) {
      case 'live':
        return 'Canlı TV';
      case 'movie':
        return 'Filmler';
      case 'series':
        return 'Diziler';
      default:
        return 'IPTV Player';
    }
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
                builder: (context) =>
                    CategoryDetailScreen(category: categories[index]),
              ),
            );
          },
          onContentTap: (content) {
            navigateByContentType(context, content);
          },
        );
      },
    );
  }
}
