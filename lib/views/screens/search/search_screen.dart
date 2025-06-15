import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void stopSearch() {
    setState(() {
      isSearching = false;
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ara...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                autofocus: true,
                onChanged: (value) {
                  // Arama fonksiyonunu burada çağırabilirsin
                  print('Aranan: $value');
                },
              )
            : Text('Ana Sayfa'),
        actions: [
          if (isSearching)
            IconButton(icon: Icon(Icons.clear), onPressed: stopSearch)
          else
            IconButton(icon: Icon(Icons.search), onPressed: startSearch),
        ],
      ),
      body: Center(child: Text('İçerik burada')),
    );
  }
}
