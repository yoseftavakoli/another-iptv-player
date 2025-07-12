import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:flutter/material.dart';

class CategoryAppBar extends StatelessWidget {
  final String title;
  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onSearchStart;
  final VoidCallback onSearchStop;
  final ValueChanged<String> onSearchChanged;

  const CategoryAppBar({
    super.key,
    required this.title,
    required this.isSearching,
    required this.searchController,
    required this.onSearchStart,
    required this.onSearchStop,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      title: isSearching ? _buildSearchField(context) : Text(title),
      actions: [
        IconButton(
          icon: Icon(isSearching ? Icons.clear : Icons.search),
          onPressed: isSearching ? onSearchStop : onSearchStart,
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: context.loc.search,
        border: InputBorder.none,
      ),
      autofocus: true,
      onChanged: onSearchChanged,
    );
  }
}
