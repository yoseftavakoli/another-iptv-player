import 'package:flutter/material.dart';
import 'package:another_iptv_player/models/category_view_model.dart';
import 'package:another_iptv_player/models/playlist_content_model.dart';
import '../services/content_service.dart';

class CategoryDetailController extends ChangeNotifier {
  final CategoryViewModel category;
  final ContentService _contentService = ContentService();

  CategoryDetailController(this.category) {
    loadContent();
  }

  // State
  List<ContentItem> _contentItems = [];
  List<ContentItem> _filteredItems = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _errorMessage;

  // Getters
  List<ContentItem> get contentItems => _contentItems;
  List<ContentItem> get filteredItems => _filteredItems;
  List<ContentItem> get displayItems => _isSearching ? _filteredItems : _contentItems;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => displayItems.isEmpty && !_isLoading;

  // Actions
  Future<void> loadContent() async {
    try {
      _setLoading(true);
      _contentItems = await _contentService.fetchContentByCategory(category);
      _setLoading(false);
    } catch (error) {
      _setError(error.toString());
    }
  }

  void startSearch() {
    _isSearching = true;
    _filteredItems = [];
    notifyListeners();
  }

  void stopSearch() {
    _isSearching = false;
    _filteredItems = [];
    notifyListeners();
  }

  void searchContent(String query) {
    if (query.trim().isEmpty) {
      _filteredItems = [];
    } else {
      _filteredItems = _contentItems
          .where((item) => item.name.toLowerCase().contains(query.trim().toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String error) {
    _isLoading = false;
    _errorMessage = error;
    notifyListeners();
  }
}