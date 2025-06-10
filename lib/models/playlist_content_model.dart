class ContentItem {
  final String name;
  final String imagePath;
  final String? description;
  final Duration? duration;

  ContentItem(this.name, this.imagePath, {this.description, this.duration});
}

class PlaylistContentModel {
  final Map<int, List<String>> categories = {
    0: ['Haber', 'Spor', 'Müzik', 'Eğlence', 'Belgesel', 'Çocuk'],
    1: ['Aksiyon', 'Komedi', 'Drama', 'Korku', 'Bilim Kurgu', 'Romantik'],
    2: ['Türk Dizileri', 'Yabancı Diziler', 'Komedi Dizileri', 'Drama Dizileri'],
  };

  final Map<String, List<ContentItem>> contents = {
    'Haber': [
      ContentItem('TRT Haber', 'assets/channel1.png', description: 'Güncel haberler'),
      ContentItem('CNN Türk', 'assets/channel2.png', description: 'Dünya haberleri'),
      ContentItem('NTV', 'assets/channel3.png', description: 'Ekonomi ve politika'),
      ContentItem('Habertürk', 'assets/channel4.png', description: 'Gündem haberleri'),
      ContentItem('A Haber', 'assets/channel5.png', description: 'Canlı yayın'),
    ],
    'Spor': [
      ContentItem('TRT Spor', 'assets/sport1.png', description: 'Spor haberleri'),
      ContentItem('S Sport', 'assets/sport2.png', description: 'Canlı maçlar'),
      ContentItem('beIN Sports', 'assets/sport3.png', description: 'Futbol yayınları'),
      ContentItem('Tivibu Spor', 'assets/sport4.png', description: 'Spor programları'),
    ],
    'Aksiyon': [
      ContentItem('John Wick', 'assets/movie1.png', description: 'Aksiyon gerilim', duration: Duration(hours: 1, minutes: 43)),
      ContentItem('Fast & Furious', 'assets/movie2.png', description: 'Hız ve aksiyon', duration: Duration(hours: 2, minutes: 17)),
      ContentItem('Mission Impossible', 'assets/movie3.png', description: 'Casusluk aksiyonu', duration: Duration(hours: 2, minutes: 43)),
      ContentItem('The Matrix', 'assets/movie4.png', description: 'Bilim kurgu aksiyonu', duration: Duration(hours: 2, minutes: 16)),
      ContentItem('Avengers', 'assets/movie5.png', description: 'Süper kahraman aksiyonu', duration: Duration(hours: 2, minutes: 23)),
    ],
    'Türk Dizileri': [
      ContentItem('Ezel', 'assets/series1.png', description: 'Dram dizisi'),
      ContentItem('Kurtlar Vadisi', 'assets/series2.png', description: 'Aksiyon dizisi'),
      ContentItem('Magnificent Century', 'assets/series3.png', description: 'Tarhi dizi'),
    ],
  };

  List<String> getCategoriesForTab(int tabIndex) {
    return categories[tabIndex] ?? [];
  }

  List<ContentItem> getContentForCategory(String category) {
    return contents[category] ?? [];
  }
}