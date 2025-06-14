import 'package:flutter/material.dart';
import 'package:iptv_player/models/category_view_model.dart';
import 'package:iptv_player/models/playlist_content_model.dart';
import 'package:iptv_player/models/view_state.dart';
import 'package:iptv_player/repositories/iptv_repository.dart';

class HomeController extends ChangeNotifier {
  late PageController _pageController;
  final IptvRepository _repository;
  String? _errorMessage;
  ViewState _viewState = ViewState.idle;

  int _currentIndex = 0;
  bool _isLoading = false;

  // Kategoriler
  List<CategoryViewModel>? _liveCategories = [];
  List<CategoryViewModel>? _movieCategories = [];
  List<CategoryViewModel>? _seriesCategories = [];

  // Getters
  PageController get pageController => _pageController;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  List<CategoryViewModel>? get liveCategories => _liveCategories;
  List<CategoryViewModel>? get movieCategories => _movieCategories;
  List<CategoryViewModel>? get seriesCategories => _seriesCategories;

  HomeController({required IptvRepository repository})
    : _repository = repository {
    _pageController = PageController();
    _loadCategories();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onNavigationTap(int index) {
    _currentIndex = index;
    notifyListeners();

    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  String getPageTitle() {
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

  String getCurrentPageType() {
    switch (_currentIndex) {
      case 0:
        return 'live';
      case 1:
        return 'movie';
      case 2:
        return 'series';
      default:
        return 'live';
    }
  }

  void _setViewState(ViewState state) {
    _viewState = state;
    if (state != ViewState.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  // Private methods
  Future<void> _loadCategories() async {
    try {
      var liveCategories = await _repository.getLiveCategories();
      for (var liveCategory in liveCategories!) {
        var liveStreams = await _repository.getLiveChannelsByCategoryId(
          categoryId: liveCategory.categoryId,
        );

        var categoryViewModel = CategoryViewModel(
          category: liveCategory,
          contentItems: liveStreams!
              .map(
                (x) => ContentItem(
                  x.streamId,
                  x.name,
                  x.streamIcon,
                  ContentType.liveStream,
                  liveStream: x,
                ),
              )
              .toList(),
        );
        _liveCategories!.add(categoryViewModel);
      }

      var movieCategories = await _repository.getVodCategories();
      for (var movieCategory in movieCategories!) {
        var movies = await _repository.getMovies(
          categoryId: movieCategory.categoryId,
        );

        var categoryViewModel = CategoryViewModel(
          category: movieCategory,
          contentItems: movies!
              .map(
                (x) => ContentItem(
                  x.streamId,
                  x.name,
                  x.streamIcon,
                  ContentType.vod,
                  containerExtension: x.containerExtension,
                  vodStream: x,
                ),
              )
              .toList(),
        );

        _movieCategories!.add(categoryViewModel);
      }

      var seriesCategories = await _repository.getSeriesCategories();
      for (var seriesCategory in seriesCategories!) {
        var series = await _repository.getSeries(
          categoryId: seriesCategory.categoryId,
        );

        var categoryViewModel = CategoryViewModel(
          category: seriesCategory,
          contentItems: series!
              .map(
                (x) => ContentItem(
                  x.seriesId,
                  x.name,
                  x.cover,
                  ContentType.series,
                  seriesStream: x,
                ),
              )
              .toList(),
        );
        _seriesCategories!.add(categoryViewModel);
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Kategoriler yüklenemedi: $e';
      _setViewState(ViewState.error);
    }
  }
}
