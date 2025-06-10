import 'package:flutter/material.dart';
import 'package:iptv_player/models/category.dart';
import 'package:iptv_player/models/playlist_content_model.dart';
import 'package:iptv_player/repositories/iptv_repository.dart';

enum ViewState { idle, loading, error, success }

class PlaylistContentController extends ChangeNotifier {
  final IptvRepository _repository;

  PlaylistContentController({required IptvRepository repository})
    : _repository = repository {
    _loadCategoriesForCurrentTab();
  }

  // State variables
  int _selectedNavIndex = 0;
  Category? _selectedCategory;
  ViewState _viewState = ViewState.idle;
  String? _errorMessage;

  // Data
  List<Category>? _currentCategories = [];
  List<ContentItem> _currentContent = [];
  String? _playlistName;

  // Getters
  int get selectedNavIndex => _selectedNavIndex;
  Category? get selectedCategory => _selectedCategory;
  ViewState get viewState => _viewState;
  String? get errorMessage => _errorMessage;
  List<Category>? get currentCategories => _currentCategories;
  List<ContentItem> get currentContent => _currentContent;
  String? get playlistName => _playlistName;

  bool get isLoading => _viewState == ViewState.loading;
  bool get hasError => _viewState == ViewState.error;
  bool get isEmpty =>
      _currentContent.isEmpty && _viewState == ViewState.success;

  // Navigation actions
  Future<void> selectNavigationTab(int index) async {
    if (_selectedNavIndex != index) {
      _selectedNavIndex = index;
      _selectedCategory = null;
      _currentContent.clear();

      await _loadCategoriesForCurrentTab();
    }
  }

  Future<void> selectCategory(Category category) async {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      await _loadContentForCategory(category);
    }
  }

  void clearCategorySelection() {
    if (_selectedCategory != null) {
      _selectedCategory = null;
      _currentContent.clear();
      notifyListeners();
    }
  }

  // Private methods
  Future<void> _loadCategoriesForCurrentTab() async {
    try {
      switch (selectedNavIndex) {
        case 0:
          _currentCategories = await _repository.getLiveCategories();
        case 1:
          _currentCategories = await _repository.getVodCategories();
        case 2:
          _currentCategories = await _repository.getSeriesCategories();
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Kategoriler yüklenemedi: $e';
      _setViewState(ViewState.error);
    }
  }

  Future<void> _loadContentForCategory(Category category) async {
    try {
      _setViewState(ViewState.loading);
      _currentContent = [];
      switch (selectedNavIndex) {
        case 0:
          var liveStreams = await _repository.getLiveChannelsByCategoryId(
            categoryId: category.categoryId,
          );
          liveStreams!.forEach(
            (x) => {_currentContent.add(ContentItem(x.name, x.streamIcon))},
          );
        case 1:
          var movies = await _repository.getMovies(
            categoryId: category.categoryId,
          );
          movies!.forEach(
            (x) => {_currentContent.add(ContentItem(x.name, x.streamIcon))},
          );
        case 2:
          var series = await _repository.getSeries(
            categoryId: category.categoryId,
          );
          series!.forEach(
            (x) => {_currentContent.add(ContentItem(x.name, x.cover))},
          );
      }

      _setViewState(ViewState.success);
    } catch (e) {
      _errorMessage = 'İçerikler yüklenemedi: $e';
      _setViewState(ViewState.error);
    }
  }

  void _setViewState(ViewState state) {
    _viewState = state;
    if (state != ViewState.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  // Content actions
  Future<void> onContentTap(ContentItem item) async {
    // İçerik seçildiğinde yapılacak işlemler
    // Örneğin: video player'ı başlat, analytics gönder, vb.
    print('Content selected: ${item.name}');
  }

  // Retry mechanism
  Future<void> retry() async {
    if (_selectedCategory != null) {
      await _loadContentForCategory(_selectedCategory!);
    } else {
      await _loadCategoriesForCurrentTab();
    }
  }

  // UI Helper methods
  IconData getIconForCurrentTab() {
    switch (_selectedNavIndex) {
      case 0:
        return Icons.live_tv;
      case 1:
        return Icons.movie;
      case 2:
        return Icons.tv;
      default:
        return Icons.play_circle_outline;
    }
  }

  Color getColorForCurrentTab() {
    switch (_selectedNavIndex) {
      default:
        return Colors.blue;
    }
  }

  String getTabName() {
    switch (_selectedNavIndex) {
      case 0:
        return 'Canlı Yayın';
      case 1:
        return 'Filmler';
      case 2:
        return 'Diziler';
      default:
        return '';
    }
  }

  // Cleanup
  @override
  void dispose() {
    super.dispose();
  }
}
