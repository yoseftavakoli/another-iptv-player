import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class IPTVMainScreen extends StatefulWidget {
  @override
  _IPTVMainScreenState createState() => _IPTVMainScreenState();
}

class _IPTVMainScreenState extends State<IPTVMainScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  // Kategoriler
  final List<String> liveCategories = [
    'Haber',
    'Spor',
    'Eğlence',
    'Müzik',
    'Çocuk',
    'Belgesel',
  ];
  final List<String> movieCategories = [
    'Aksiyon',
    'Komedi',
    'Drama',
    'Korku',
    'Bilim Kurgu',
    'Romantik',
  ];
  final List<String> seriesCategories = [
    'Dizi',
    'Belgesel',
    'Çizgi Film',
    'Reality',
    'Suç',
    'Tarih',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String _getPageTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Canlı Yayınlar';
      case 1:
        return 'Filmler';
      case 2:
        return 'Diziler';
      default:
        return 'IP TV Player';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildContentPage(liveCategories, 'live'),
          _buildContentPage(movieCategories, 'movie'),
          _buildContentPage(seriesCategories, 'series'),
        ],
      ),
      // Özel BottomNavigationBar - overflow problemi çözümü
      bottomNavigationBar: Material(
        elevation: 8,
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.live_tv, 'Canlı'),
              _buildNavItem(1, Icons.movie_outlined, 'Film'),
              _buildNavItem(2, Icons.tv, 'Dizi'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onNavigationTap(index),
        child: Container(
          height: 65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: isSelected ? 22 : 20,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: isSelected ? 11 : 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentPage(List<String> categories, String type) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Text(
              _getPageTitle(),
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

  Widget _buildCategoryList(List<String> categories, String type) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildCategorySection(categories[index], type);
      },
    );
  }

  Widget _buildCategorySection(String category, String type) {
    List<ContentItem> contents = _generateCategoryContent(type, category);

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Kategori başlığı
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    category,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailScreen(
                          category: category,
                          type: type,
                          contents: _generateCategoryContent(
                            type,
                            category,
                            fullList: true,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text('Tümünü Gör', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
          // Yatay içerik listesi
          SizedBox(
            height: _getCardHeight(),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: contents.length,
              itemBuilder: (context, index) {
                return Container(
                  width: _getCardWidth(),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: _buildContentCard(contents[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _getCardWidth() {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1200) {
      return 160;
    } else if (screenWidth >= 600) {
      return 130;
    } else {
      return 110;
    }
  }

  double _getCardHeight() {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1200) {
      return 220;
    } else if (screenWidth >= 600) {
      return 190;
    } else {
      return 160;
    }
  }

  Widget _buildContentCard(ContentItem content) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContentDetailScreen(content: content),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Görsel veya başlık
            Expanded(
              flex: 3,
              child: content.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: content.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          _buildTitleCard(content.title),
                    )
                  : _buildTitleCard(content.title),
            ),
            // Başlık ve açıklama
            Container(
              height: 45,
              padding: EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      content.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (content.subtitle != null) ...[
                    SizedBox(height: 1),
                    Flexible(
                      child: Text(
                        content.subtitle!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleCard(String title) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  List<ContentItem> _generateCategoryContent(
    String type,
    String category, {
    bool fullList = false,
  }) {
    List<ContentItem> contents = [];
    int itemCount = fullList ? 30 : 10;

    for (int i = 1; i <= itemCount; i++) {
      String title;
      String? subtitle;
      String? imageUrl;

      switch (type) {
        case 'live':
          title = '$category $i';
          subtitle = 'Canlı';
          if (i % 3 == 0) {
            imageUrl =
                'https://picsum.photos/200/300?random=${category.hashCode + i}';
          }
          break;
        case 'movie':
          title = '$category $i';
          subtitle = '2023';
          if (i % 2 == 0) {
            imageUrl =
                'https://picsum.photos/200/300?random=${category.hashCode + i + 100}';
          }
          break;
        case 'series':
          title = '$category $i';
          subtitle = 'S1';
          if (i % 4 == 0) {
            imageUrl =
                'https://picsum.photos/200/300?random=${category.hashCode + i + 200}';
          }
          break;
        default:
          title = 'İçerik $i';
      }

      contents.add(
        ContentItem(
          id: '${type}_${category}_$i',
          title: title,
          subtitle: subtitle,
          imageUrl: imageUrl,
          type: type,
          category: category,
        ),
      );
    }

    return contents;
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final String category;
  final String type;
  final List<ContentItem> contents;

  CategoryDetailScreen({
    required this.category,
    required this.type,
    required this.contents,
  });

  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1200) {
      return 6;
    } else if (screenWidth >= 900) {
      return 5;
    } else if (screenWidth >= 600) {
      return 4;
    } else if (screenWidth >= 400) {
      return 3;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(context),
          childAspectRatio: 0.65,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: contents.length,
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ContentDetailScreen(content: contents[index]),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 4,
                    child: contents[index].imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: contents[index].imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceVariant,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceVariant,
                              child: Center(
                                child: Text(
                                  contents[index].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Center(
                              child: Text(
                                contents[index].title,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            contents[index].title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (contents[index].subtitle != null) ...[
                            SizedBox(height: 2),
                            Text(
                              contents[index].subtitle!,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ContentItem {
  final String id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String type;
  final String category;

  ContentItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    required this.type,
    required this.category,
  });
}

class ContentDetailScreen extends StatelessWidget {
  final ContentItem content;

  ContentDetailScreen({required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(content.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: content.id,
              child: Container(
                height: 300,
                child: content.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: content.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: Center(
                            child: Text(
                              content.title,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Center(
                          child: Text(
                            content.title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (content.subtitle != null)
                    Text(
                      content.subtitle!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  SizedBox(height: 16),
                  Chip(label: Text('Kategori: ${content.category}')),
                  SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${content.title} oynatılıyor...'),
                        ),
                      );
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text('Oynat'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
